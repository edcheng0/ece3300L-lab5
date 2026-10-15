`timescale 1ns / 1ps
// Lab 3 rudimentary driver (RECREATED - swap in your own Lab 3 file if you have it,
// and match the port names in first_sseg_driver_test.v).
// Shows 4-bit "num" on the digit chosen by "active_digit". All outputs active-low.
module first_sseg_driver(
    input  [2:0] active_digit,
    input  [3:0] num,
    input        DP_in,        // 0 = decimal point lit
    output [6:0] sseg,
    output [0:7] AN,
    output       DP
    );
    wire [0:7] y;
    decoder_generic #(.N(3)) dec (.w(active_digit), .en(1'b1), .y(y));
    assign AN = ~y;            // AN[k] = ~y[k] (both declared [0:7])
    hex2sseg h2s (.hex(num), .sseg(sseg));
    assign DP = DP_in;
endmodule
