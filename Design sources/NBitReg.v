`timescale 1ns / 1ps


module NBitReg #(parameter n=32)(input clk, load, rst, input [n-1:0]D, output [n-1:0] Q );

wire [n-1:0] C; 
genvar i;
generate
for(i=0;i<n;i=i+1)
begin : block
    MUX_bit MUX_bit( Q[i], D[i], load,   C[i]);
    DFlipFlop D1(clk, rst, C[i], Q[i]);
end
endgenerate    
endmodule
