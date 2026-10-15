`timescale 1ns / 1ps
module tb_bin2bcd;
    reg [7:0] b; wire [11:0] bcd; reg [11:0] exp; integer n, errors = 0;
    bin2bcd dut(.bin(b), .bcd(bcd));
    initial begin
        for (n = 0; n < 256; n = n + 1) begin
            b = n; exp[11:8] = b/100; exp[7:4] = (b/10)%10; exp[3:0] = b%10; #1;
            if (bcd !== exp) begin errors = errors + 1; $display("FAIL %0d -> %h", n, bcd); end
        end
        if (errors == 0) $display("PASS: tb_bin2bcd - all 256 values"); else $display("FAILED %0d", errors);
    end
endmodule
