`timescale 1ns / 1ps
// Part 2 testbench: FINAL_VALUE=9 -> 10 clocks per digit, 80 per frame.
// Checks every time slot: right anode only, right segments, DP, and dark digits.
module tb_sseg_driver;
    reg clk = 0, reset_n = 0;
    reg [5:0] i [0:7];
    wire [6:0] sseg; wire [0:7] AN; wire DP;
    integer errors = 0, slot, frame;
    wire [6:0] seg_lut [0:15];
    genvar g;
    generate for (g = 0; g < 16; g = g + 1) begin : lut
        hex2sseg h (.hex(g[3:0]), .sseg(seg_lut[g]));
    end endgenerate

    sseg_driver #(.FINAL_VALUE(9)) dut (
        .clk(clk), .reset_n(reset_n),
        .i0(i[0]), .i1(i[1]), .i2(i[2]), .i3(i[3]),
        .i4(i[4]), .i5(i[5]), .i6(i[6]), .i7(i[7]),
        .sseg(sseg), .AN(AN), .DP(DP));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_sseg_driver.vcd");
        $dumpvars(0, tb_sseg_driver);
        // "42" on the two right digits (dots off), digit 2 = "A." (dot on), digit 5 = F (dot off),
        // digit 3 disabled but holding a non-zero hex value, rest blank
        i[0] = 6'b1_0010_1;  i[1] = 6'b1_0100_1;  i[2] = 6'b1_1010_0;
        i[3] = 6'b0_1111_0;  i[4] = 6'b0_0000_1;  i[5] = 6'b1_1111_1;
        i[6] = 6'b0_0000_0;  i[7] = 6'b1_1000_0;                       // digit 7 = "C."
        repeat (3) @(negedge clk);
        reset_n = 1;
        for (frame = 0; frame < 3; frame = frame + 1)
            for (slot = 0; slot < 8; slot = slot + 1) begin
                repeat (5) @(negedge clk);
                if (i[slot][5]) begin
                    if (AN !== ~(8'h80 >> slot)) begin errors = errors + 1; $display("FAIL slot %0d AN=%b", slot, AN); end
                    if (sseg !== seg_lut[i[slot][4:1]]) begin errors = errors + 1; $display("FAIL slot %0d sseg=%b", slot, sseg); end
                    if (DP !== i[slot][0]) begin errors = errors + 1; $display("FAIL slot %0d DP=%b", slot, DP); end
                end else begin
                    if (AN !== 8'hFF) begin errors = errors + 1; $display("FAIL slot %0d should be dark, AN=%b", slot, AN); end
                end
                repeat (5) @(negedge clk);
            end
        // asynchronous reset restarts the scan at digit 0
        #3 reset_n = 0; #1;
        if (dut.count_out !== 3'd0) begin errors = errors + 1; $display("FAIL reset"); end
        if (errors == 0) $display("PASS: tb_sseg_driver - 3 frames, all 8 slots correct (enable, hex, DP)");
        else $display("FAILED with %0d errors", errors);
        $finish;
    end
endmodule
