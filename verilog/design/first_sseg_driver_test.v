`timescale 1ns / 1ps
// Part 1: timer -> 3-bit up counter -> Lab 3 driver. Digit k shows k.
module first_sseg_driver_test
    #(parameter FINAL_VALUE = 99_999)(   // 1 ms per step
    input        clk,
    input        reset_n,
    output [6:0] sseg,
    output [0:7] AN,
    output       DP
    );
    wire       done;
    wire [2:0] count_out;

    timer_parameter #(.FINAL_VALUE(FINAL_VALUE)) timer (
        .clk(clk), .reset_n(reset_n), .enable(1'b1), .done(done));

    udl_counter #(.BITS(3)) cnt (
        .clk(clk), .reset_n(reset_n), .enable(done),
        .up(1'b1), .load(1'b0), .D(3'b000), .Q(count_out));

    first_sseg_driver drv (
        .active_digit(count_out), .num({1'b0, count_out}),
        .DP_in(1'b0), .sseg(sseg), .AN(AN), .DP(DP));
endmodule
