/*
 * Tiny Tapeout GF180 wrapper scaffold.
 *
 * This file is copied from the official ttgf-verilog-template interface.
 * The internal chess-clock pin allocation is intentionally left for the
 * designer to complete: the clock has 6 control inputs and 19 status/display
 * outputs, while the template exposes 8 dedicated inputs, 8 dedicated
 * outputs, and 8 bidirectional pins.
 */
`default_nettype none

module tt_um_guitarfan_ultimate_chess_clock (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // TODO: connect the selected Tiny Tapeout pins to ultimate_chess_clock.
    // Do not submit this scaffold until the pin allocation is finalized.
    assign uo_out = 8'b0;
    assign uio_out = 8'b0;
    assign uio_oe = 8'b0;

    wire _unused = &{ena, ui_in, uio_in, clk, rst_n};

endmodule
