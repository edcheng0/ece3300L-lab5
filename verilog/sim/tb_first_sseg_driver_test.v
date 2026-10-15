`timescale 1ns / 1ps
// Part 1 testbench: FINAL_VALUE overridden to 9 so each count step is 10 clocks.
module tb_first_sseg_driver_test;
    reg clk = 0, reset_n = 0;
    wire [6:0] sseg; wire [0:7] AN; wire DP;
    integer errors = 0, k, steps;
    reg [6:0] exp_seg [0:7];
    wire [6:0] seg_lut [0:7];
    genvar g;
    generate for (g = 0; g < 8; g = g + 1) begin : lut
        hex2sseg h (.hex(g[3:0]), .sseg(seg_lut[g]));
    end endgenerate

    first_sseg_driver_test #(.FINAL_VALUE(9)) dut (
        .clk(clk), .reset_n(reset_n), .sseg(sseg), .AN(AN), .DP(DP));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_first_sseg_driver_test.vcd");
        $dumpvars(0, tb_first_sseg_driver_test);
        repeat (3) @(negedge clk);
        reset_n = 1;
        for (steps = 0; steps < 16; steps = steps + 1) begin   // two full laps
            k = steps % 8;
            repeat (5) @(negedge clk);                            // middle of the step
            if (AN !== ~(8'h80 >> k)) begin
                errors = errors + 1; $display("FAIL step %0d: AN=%b", steps, AN);
            end
            if (sseg !== seg_lut[k]) begin
                errors = errors + 1; $display("FAIL step %0d: sseg=%b exp %b", steps, sseg, seg_lut[k]);
            end
            if (DP !== 1'b0) begin errors = errors + 1; $display("FAIL DP not lit"); end
            repeat (5) @(negedge clk);
        end
        if (errors == 0) $display("PASS: tb_first_sseg_driver_test - digit k showed k on AN[k], DP lit, wrapped 7->0");
        else $display("FAILED with %0d errors", errors);
        $finish;
    end
endmodule
