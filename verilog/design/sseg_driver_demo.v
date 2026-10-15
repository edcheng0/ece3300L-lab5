`timescale 1ns / 1ps
// Optional board demo for Part 2: shows 7 6 5 4 3 2 1 0 (dot on digit 1).
// SW[k] enables digit k, so you can see the enable bit work.
module sseg_driver_demo(
    input        CLK100MHZ,
    input        CPU_RESETN,
    input  [7:0] SW,
    output [6:0] sseg,
    output [0:7] AN,
    output       DP
    );
    sseg_driver drv (
        .clk(CLK100MHZ), .reset_n(CPU_RESETN),
        .i0({SW[0], 4'd0, 1'b1}), .i1({SW[1], 4'd1, 1'b0}),   // digit 1 has its dot on
        .i2({SW[2], 4'd2, 1'b1}), .i3({SW[3], 4'd3, 1'b1}),
        .i4({SW[4], 4'd4, 1'b1}), .i5({SW[5], 4'd5, 1'b1}),
        .i6({SW[6], 4'd6, 1'b1}), .i7({SW[7], 4'd7, 1'b1}),
        .sseg(sseg), .AN(AN), .DP(DP));
endmodule
