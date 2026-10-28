module ultimate_chess_clock #(
    parameter int unsigned DEFAULT_MINUTES = 10,
    parameter int unsigned MAX_MINUTES     = 99,
    parameter int unsigned MAX_INCREMENT   = 60
) (
    input  logic        clk,
    input  logic        reset,

    // One-clock-wide pulse representing one elapsed second.
    input  logic        one_second_tick,

    // Asynchronous external buttons are synchronized internally.
    // External hardware debounce is recommended.
    input  logic        player1_button,
    input  logic        player2_button,
    input  logic        mode_button,
    input  logic        plus_button,
    input  logic        minus_button,

    // Four packed BCD digits in MMSS order.
    output logic [15:0] player1_display,
    output logic [15:0] player2_display,

    // Optional status outputs.
    output logic        running,
    output logic        active_player, // 0 = player 1, 1 = player 2
    output logic        timeout
);

    localparam logic [2:0] FIELD_P1_MIN = 3'd0;
    localparam logic [2:0] FIELD_P1_SEC = 3'd1;
    localparam logic [2:0] FIELD_P2_MIN = 3'd2;
    localparam logic [2:0] FIELD_P2_SEC = 3'd3;
    localparam logic [2:0] FIELD_INC    = 3'd4;

    localparam int MIN_W = (MAX_MINUTES < 2) ? 1 : $clog2(MAX_MINUTES + 1);
    localparam int SEC_W = 6;
    localparam int INC_W = (MAX_INCREMENT < 2) ? 1 : $clog2(MAX_INCREMENT + 1);

    logic [MIN_W-1:0] p1_minutes;
    logic [SEC_W-1:0] p1_seconds;
    logic [MIN_W-1:0] p2_minutes;
    logic [SEC_W-1:0] p2_seconds;
    logic [INC_W-1:0] increment_seconds;

    logic [2:0] setup_field;

    // Button synchronizers.
    logic p1_meta, p1_sync, p1_sync_d;
    logic p2_meta, p2_sync, p2_sync_d;
    logic mode_meta, mode_sync, mode_sync_d;
    logic plus_meta, plus_sync, plus_sync_d;
    logic minus_meta, minus_sync, minus_sync_d;

    wire p1_press    = p1_sync    & ~p1_sync_d;
    wire p2_press    = p2_sync    & ~p2_sync_d;
    wire mode_press  = mode_sync  & ~mode_sync_d;
    wire plus_press  = plus_sync  & ~plus_sync_d;
    wire minus_press = minus_sync & ~minus_sync_d;

    /*
     * Convert binary minutes and seconds to packed BCD MMSS.

     * The bounded loops are display-only logic and do not affect the timer
     * datapath. MAX_MINUTES defaults to 99 so the display remains MMSS.
     */
    function automatic logic [15:0] make_display(
        input logic [MIN_W-1:0] minutes,
        input logic [SEC_W-1:0] seconds
    );
        integer minute_value;
        integer second_value;
        integer minute_tens;
        integer second_tens;
        integer i;

        begin
            minute_value = minutes;
            second_value = seconds;

            minute_tens = 0;
            second_tens = 0;

            // Convert minutes to two decimal digits.
            for (i = 0; i < 9; i = i + 1) begin
                if (minute_value >= 10) begin
                    minute_value = minute_value - 10;
                    minute_tens = minute_tens + 1;
                end
            end

            // Convert seconds to two decimal digits.
            for (i = 0; i < 5; i = i + 1) begin
                if (second_value >= 10) begin
                    second_value = second_value - 10;
                    second_tens = second_tens + 1;
                end
            end

            make_display = {
                minute_tens[3:0],
                minute_value[3:0],
                second_tens[3:0],
                second_value[3:0]
            };
        end
    endfunction

    assign player1_display = make_display(p1_minutes, p1_seconds);
    assign player2_display = make_display(p2_minutes, p2_seconds);

    /*
     * Synchronizers and edge detectors.

     * Inputs are sampled in one clock domain. A real implementation should
     * use external RC or digital debounce circuitry, or increase the debounce
     * logic as required by the board hardware.
     */
    always_ff @(posedge clk) begin
        if (reset) begin
            p1_meta    <= 1'b0;
            p1_sync    <= 1'b0;
            p1_sync_d  <= 1'b0;

            p2_meta    <= 1'b0;
            p2_sync    <= 1'b0;
            p2_sync_d  <= 1'b0;

            mode_meta  <= 1'b0;
            mode_sync  <= 1'b0;
            mode_sync_d <= 1'b0;

            plus_meta  <= 1'b0;
            plus_sync  <= 1'b0;
            plus_sync_d <= 1'b0;

            minus_meta <= 1'b0;
            minus_sync <= 1'b0;
            minus_sync_d <= 1'b0;
        end
        else begin
            p1_meta   <= player1_button;
            p1_sync   <= p1_meta;
            p1_sync_d <= p1_sync;

            p2_meta   <= player2_button;
            p2_sync   <= p2_meta;
            p2_sync_d <= p2_sync;

            mode_meta   <= mode_button;
            mode_sync   <= mode_meta;
            mode_sync_d <= mode_sync;

            plus_meta   <= plus_button;
            plus_sync   <= plus_meta;
            plus_sync_d <= plus_sync;

            minus_meta   <= minus_button;
            minus_sync   <= minus_meta;
            minus_sync_d <= minus_sync;
        end
    end

    /*
     * Main state machine.

     * While stopped:
     *   - MODE cycles through the five setup fields.
     *   - PLUS and MINUS adjust the selected field.
     *   - PLAYER 1 or PLAYER 2 starts the game and selects the active player.

     * While running:
     *   - MODE pauses the clock.
     *   - A player button ends the active player's turn, adds Fischer
     *     increment to the player who just moved, and changes turns.
     *   - one_second_tick decrements only the active player's clock.

     * Button priority:
     *   MODE has priority over player buttons.
     *   PLUS has priority over MINUS while stopped.
     */
    always_ff @(posedge clk) begin
        if (reset) begin
            p1_minutes      <= DEFAULT_MINUTES[MIN_W-1:0];
            p1_seconds      <= '0;
            p2_minutes      <= DEFAULT_MINUTES[MIN_W-1:0];
            p2_seconds      <= '0;
            increment_seconds <= '0;

            setup_field  <= FIELD_P1_MIN;
            running      <= 1'b0;
            active_player <= 1'b0;
            timeout      <= 1'b0;
        end
        else begin
            if (mode_press) begin
                if (running) begin
                    // MODE pauses a running game.
                    running <= 1'b0;
                end
                else begin
                    // MODE selects the next setup field.
                    if (setup_field == FIELD_INC)
                        setup_field <= FIELD_P1_MIN;
                    else
                        setup_field <= setup_field + 3'd1;
                end
            end
            else if (running) begin
                /*
                 * Player buttons switch turns only when the opposite player
                 * presses. A press by the active player is ignored.
                 */
                if ((active_player == 1'b0) && p2_press) begin
                    // Player 1 completed a move.
                    if (increment_seconds != 0) begin
                        if (p1_seconds + increment_seconds >= 60) begin
                            if (p1_minutes < MAX_MINUTES)
                                p1_minutes <= p1_minutes + 1'b1;

                            p1_seconds <= p1_seconds + increment_seconds - 60;
                        end
                        else begin
                            p1_seconds <= p1_seconds + increment_seconds;
                        end
                    end

                    active_player <= 1'b1;
                end
                else if ((active_player == 1'b1) && p1_press) begin
                    // Player 2 completed a move.
                    if (increment_seconds != 0) begin
                        if (p2_seconds + increment_seconds >= 60) begin
                            if (p2_minutes < MAX_MINUTES)
                                p2_minutes <= p2_minutes + 1'b1;

                            p2_seconds <= p2_seconds + increment_seconds - 60;
                        end
                        else begin
                            p2_seconds <= p2_seconds + increment_seconds;
                        end
                    end

                    active_player <= 1'b0;
                end
                else if (one_second_tick) begin
                    if (active_player == 1'b0) begin
                        if ((p1_minutes == 0) && (p1_seconds == 0)) begin
                            running <= 1'b0;
                            timeout <= 1'b1;
                        end
                        else if (p1_seconds != 0) begin
                            p1_seconds <= p1_seconds - 1'b1;
                        end
                        else begin
                            p1_minutes <= p1_minutes - 1'b1;
                            p1_seconds <= 6'd59;
                        end
                    end
                    else begin
                        if ((p2_minutes == 0) && (p2_seconds == 0)) begin
                            running <= 1'b0;
                            timeout <= 1'b1;
                        end
                        else if (p2_seconds != 0) begin
                            p2_seconds <= p2_seconds - 1'b1;
                        end
                        else begin
                            p2_minutes <= p2_minutes - 1'b1;
                            p2_seconds <= 6'd59;
                        end
                    end
                end
            end
            else begin
                /*
                 * Stopped/setup mode.
                 *
                 * Any player button starts the clock. The pressed player's
                 * clock becomes active. Setup changes are ignored during the
                 * same cycle as a start command.
                 */
                if (p1_press) begin
                    running       <= 1'b1;
                    active_player <= 1'b0;
                    timeout       <= 1'b0;
                end
                else if (p2_press) begin
                    running       <= 1'b1;
                    active_player <= 1'b1;
                    timeout       <= 1'b0;
                end
                else if (plus_press) begin
                    case (setup_field)
                        FIELD_P1_MIN: begin
                            if (p1_minutes < MAX_MINUTES)
                                p1_minutes <= p1_minutes + 1'b1;
                        end

                        FIELD_P1_SEC: begin
                            if (p1_seconds < 59)
                                p1_seconds <= p1_seconds + 1'b1;
                        end

                        FIELD_P2_MIN: begin
                            if (p2_minutes < MAX_MINUTES)
                                p2_minutes <= p2_minutes + 1'b1;
                        end

                        FIELD_P2_SEC: begin
                            if (p2_seconds < 59)
                                p2_seconds <= p2_seconds + 1'b1;
                        end

                        FIELD_INC: begin
                            if (increment_seconds < MAX_INCREMENT)
                                increment_seconds <= increment_seconds + 1'b1;
                        end

                        default: begin
                            setup_field <= FIELD_P1_MIN;
                        end
                    endcase
                end
                else if (minus_press) begin
                    case (setup_field)
                        FIELD_P1_MIN: begin
                            if (p1_minutes != 0)
                                p1_minutes <= p1_minutes - 1'b1;
                        end

                        FIELD_P1_SEC: begin
                            if (p1_seconds != 0)
                                p1_seconds <= p1_seconds - 1'b1;
                        end

                        FIELD_P2_MIN: begin
                            if (p2_minutes != 0)
                                p2_minutes <= p2_minutes - 1'b1;
                        end

                        FIELD_P2_SEC: begin
                            if (p2_seconds != 0)
                                p2_seconds <= p2_seconds - 1'b1;
                        end

                        FIELD_INC: begin
                            if (increment_seconds != 0)
                                increment_seconds <= increment_seconds - 1'b1;
                        end

                        default: begin
                            setup_field <= FIELD_P1_MIN;
                        end
                    endcase
                end
            end
        end
    end

endmodule