`timescale 1ns / 1ps
// Part 3 testbench: follows the demo table (steps 1-12). Short timers so it simulates fast.
module tb_counter_application;
    reg clk = 0, reset_n = 0;
    reg BTNU = 0, BTND = 0, BTNC = 0;
    reg [7:0] SW = 0;
    wire [6:0] sseg; wire [0:7] AN; wire DP;

    counter_application #(.DISPLAY_FINAL(9), .DEBOUNCE_FINAL(9)) dut (
        .CLK100MHZ(clk), .CPU_RESETN(reset_n), .BTNU(BTNU), .BTND(BTND), .BTNC(BTNC),
        .SW(SW), .sseg(sseg), .AN(AN), .DP(DP));

    always #5 clk = ~clk;

    // press a button for 300 clocks, then release
    task press(input u, input d, input c);
        begin
            @(negedge clk); BTNU = u; BTND = d; BTNC = c;
            repeat (300) @(negedge clk);
            BTNU = 0; BTND = 0; BTNC = 0;
            repeat (50) @(negedge clk);
        end
    endtask

    // compare count (and its BCD digits) with the expected value
    reg [11:0] exp_bcd;
    task check(input [7:0] expected);
        begin
            exp_bcd[11:8] = expected / 100;
            exp_bcd[7:4]  = (expected / 10) % 10;
            exp_bcd[3:0]  = expected % 10;
            if (dut.count == expected && dut.bcd == exp_bcd)
                $display("PASS: count = %0d", dut.count);
            else
                $display("FAIL: count = %0d, expected %0d", dut.count, expected);
        end
    endtask

    initial begin
        // flush X out of button.v: pulse BTNU and BTND once while reset is held
        BTNU = 1; BTND = 1; repeat (5) @(negedge clk);
        BTNU = 0; BTND = 0; repeat (5) @(negedge clk);
        reset_n = 1; repeat (5) @(negedge clk);

        check(0);                                  // 1  reset
        SW = 8'b1111_1010; repeat (20) @(negedge clk);
        check(0);                                  // 2  switches alone do nothing
        press(0,0,1); check(250);                  // 3  load
        press(1,0,0); press(1,0,0); press(1,0,0); press(1,0,0); press(1,0,0);
        check(255);                                // 4  up x5
        press(1,0,0); check(0);                    // 5  wrap 255 -> 0
        press(0,1,0); check(255);                  // 6  wrap 0 -> 255
        SW = 8'b0000_1001; press(0,0,1); check(9); // 7  load 9
        press(0,1,0); check(8);                    // 8  down
        press(1,0,0); check(9);                    // 9  one press = one count
        press(1,1,0); check(8);                    // 10 up+down together: down wins
        @(negedge clk); BTNC = 1; SW = 8'd123;     // 11 hold load, change switches
        repeat (50) @(negedge clk); BTNC = 0;
        check(123);
        @(negedge clk); reset_n = 0;               // 12 reset
        repeat (5) @(negedge clk); reset_n = 1;
        repeat (5) @(negedge clk);
        check(0);
        $finish;
    end
endmodule
