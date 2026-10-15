`timescale 1ns / 1ps
// Part 3: 0-255 up/down/load counter shown on the three rightmost digits.
// BTNU up, BTND down (down wins a tie), BTNC load SW[7:0] (level-sensitive),
// CPU_RESETN async reset to 0.
module counter_application
    #(parameter DISPLAY_FINAL  = 99_999,    // sseg_driver scan timer
      parameter DEBOUNCE_FINAL = 499_999)(  // 5 ms button sample tick
    input        CLK100MHZ,
    input        CPU_RESETN,
    input        BTNU, BTND, BTNC,
    input  [7:0] SW,
    output [6:0] sseg,
    output [0:7] AN,
    output       DP
    );
    // ---- slow sample tick: filters contact bounce before button.v ----
    wire tick;
    timer_parameter #(.FINAL_VALUE(DEBOUNCE_FINAL)) deb_timer (
        .clk(CLK100MHZ), .reset_n(CPU_RESETN), .enable(1'b1), .done(tick));

    reg up_s, down_s;
    always @(posedge CLK100MHZ, negedge CPU_RESETN)
        if (~CPU_RESETN) begin up_s <= 1'b0; down_s <= 1'b0; end
        else if (tick)   begin up_s <= BTNU;  down_s <= BTND;  end

    wire up_out, down_out;
    button b_up   (.clk(CLK100MHZ), .in(up_s),   .out(up_out));
    button b_down (.clk(CLK100MHZ), .in(down_s), .out(down_out));

    // ---- control logic ----
    wire up_dir = up_out & ~down_out;                 // down beats up
    wire en     = up_out | down_out | BTNC;           // load is level-sensitive
    wire [7:0] count;

    udl_counter #(.BITS(8)) counter (
        .clk(CLK100MHZ), .reset_n(CPU_RESETN), .enable(en),
        .up(up_dir), .load(BTNC), .D(SW), .Q(count));

    // ---- display ----
    wire [11:0] bcd;
    bin2bcd b2b (.bin(count), .bcd(bcd));

    sseg_driver #(.FINAL_VALUE(DISPLAY_FINAL)) display (
        .clk(CLK100MHZ), .reset_n(CPU_RESETN),
        .i0({1'b1, bcd[3:0],  1'b1}),
        .i1({1'b1, bcd[7:4],  1'b1}),
        .i2({1'b1, bcd[11:8], 1'b1}),
        .i3(6'b0), .i4(6'b0), .i5(6'b0), .i6(6'b0), .i7(6'b0),
        .sseg(sseg), .AN(AN), .DP(DP));
endmodule
