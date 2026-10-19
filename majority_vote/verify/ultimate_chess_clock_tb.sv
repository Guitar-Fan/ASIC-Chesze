`timescale 1ns/1ps

module ultimate_chess_clock_tb;

    logic clk;
    logic reset;
    logic one_second_tick;

    logic player1_button;
    logic player2_button;
    logic mode_button;
    logic plus_button;
    logic minus_button;

    logic [15:0] player1_display;
    logic [15:0] player2_display;
    logic running;
    logic active_player;
    logic timeout;

    ultimate_chess_clock #(
        .DEFAULT_MINUTES(10),
        .MAX_MINUTES(99),
        .MAX_INCREMENT(60)
    ) dut (
        .clk(clk),
        .reset(reset),
        .one_second_tick(one_second_tick),

        .player1_button(player1_button),
        .player2_button(player2_button),
        .mode_button(mode_button),
        .plus_button(plus_button),
        .minus_button(minus_button),

        .player1_display(player1_display),
        .player2_display(player2_display),
        .running(running),
        .active_player(active_player),
        .timeout(timeout)
    );

    always #5 clk = ~clk;

    task automatic idle_cycles(input integer count);
        repeat (count) @(posedge clk);
    endtask

    task automatic press_button(ref logic button);
        begin
            button = 1'b1;
            idle_cycles(4);
            button = 1'b0;
            idle_cycles(4);
        end
    endtask

    task automatic second_tick;
        begin
            @(negedge clk);
            one_second_tick = 1'b1;
            @(negedge clk);
            one_second_tick = 1'b0;
            idle_cycles(1);
        end
    endtask

    task automatic check_equal(
        input logic [15:0] actual,
        input logic [15:0] expected,
        input string name
    );
        begin
            if (actual !== expected) begin
                $error(
                    "%s failed: expected %h, got %h",
                    name,
                    expected,
                    actual
                );
            end
            else begin
                $display("PASS: %s", name);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        one_second_tick = 1'b0;

        player1_button = 1'b0;
        player2_button = 1'b0;
        mode_button = 1'b0;
        plus_button = 1'b0;
        minus_button = 1'b0;

        idle_cycles(3);
        reset = 1'b0;
        idle_cycles(3);

        // Default should be 10:00 for both players.
        check_equal(player1_display, 16'h1000, "player 1 default time");
        check_equal(player2_display, 16'h1000, "player 2 default time");

        // Select player 1 seconds field.
        press_button(mode_button);

        // Add two seconds to player 1.
        press_button(plus_button);
        press_button(plus_button);

        check_equal(player1_display, 16'h1002, "player 1 seconds setup");

        // Reset and verify a clean game start.
        reset = 1'b1;
        idle_cycles(2);
        reset = 1'b0;
        idle_cycles(3);

        // Player 1 starts the game.
        press_button(player1_button);

        if (!running)
            $error("Game did not start");
        else
            $display("PASS: game start");

        if (active_player !== 1'b0)
            $error("Player 1 should be active after player 1 starts");
        else
            $display("PASS: player 1 active");

        // Player 1 counts down while active.
        second_tick;
        check_equal(player1_display, 16'h0959, "player 1 countdown");

        // Player 2 presses to end player 1's move.
        press_button(player2_button);

        if (active_player !== 1'b1)
            $error("Turn did not switch to player 2");
        else
            $display("PASS: turn switched to player 2");

        // Player 1 must not count down while player 2 is active.
        second_tick;
        check_equal(player1_display, 16'h0959, "inactive player holds time");

        // Pause.
        press_button(mode_button);

        if (running)
            $error("Game did not pause");
        else
            $display("PASS: pause");

        // Setup mode can change the increment.
        // Current setup field is player 1 minutes after reset.
        // MODE cycles: P1 minutes -> P1 seconds -> P2 minutes
        // -> P2 seconds -> increment.
        press_button(mode_button);
        press_button(mode_button);
        press_button(mode_button);
        press_button(mode_button);

        press_button(plus_button);
        check_equal(player1_display, 16'h0959, "pause leaves player 1 time unchanged");

        // Resume.
        press_button(mode_button);

        if (!running)
            $error("Game did not resume");
        else
            $display("PASS: resume");

        // Player 2 completes a move. Its increment is zero in this test.
        press_button(player1_button);

        if (active_player !== 1'b0)
            $error("Turn did not switch back to player 1");
        else
            $display("PASS: second turn switch");

        // Timeout test:
        // Reset, set player 1 minutes to zero using ten MINUS presses,
        // then start player 1 and apply a tick.
        reset = 1'b1;
        idle_cycles(2);
        reset = 1'b0;
        idle_cycles(3);

        repeat (10) press_button(minus_button);

        check_equal(player1_display, 16'h0000, "player 1 zero setup");

        press_button(player1_button);
        second_tick;

        check_equal(player1_display, 16'h0000, "timeout clamps at zero");

        if (running)
            $error("Game should stop at timeout");
        else
            $display("PASS: timeout stops game");

        if (!timeout)
            $error("Timeout flag was not asserted");
        else
            $display("PASS: timeout flag");

        $display("All tests completed.");
        $finish;
    end

endmodule