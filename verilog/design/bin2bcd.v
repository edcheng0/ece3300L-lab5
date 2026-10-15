`timescale 1ns / 1ps
// 8-bit binary to 3 BCD digits (double dabble). RECREATED for Lab 2 -
// use your own Lab 2 module if you prefer and fix the port names in counter_application.v.
module bin2bcd(
    input  [7:0]  bin,
    output reg [11:0] bcd    // {hundreds, tens, ones}
    );
    integer i;
    always @(*) begin
        bcd = 12'd0;
        for (i = 7; i >= 0; i = i - 1) begin
            if (bcd[3:0]  >= 5) bcd[3:0]  = bcd[3:0]  + 3;
            if (bcd[7:4]  >= 5) bcd[7:4]  = bcd[7:4]  + 3;
            if (bcd[11:8] >= 5) bcd[11:8] = bcd[11:8] + 3;
            bcd = {bcd[10:0], bin[i]};
        end
    end
endmodule
