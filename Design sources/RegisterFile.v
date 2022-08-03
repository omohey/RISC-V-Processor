`timescale 1ns / 1ps
module RegisterFile(input [4:0] Readreg1, Readreg2, Writereg, input regWrite, clk, rst,  input [31:0] Writedata, output [31:0] ReadData1, ReadData2 );



wire [31:0] registers [31:0];
reg [31:0] loads = 0;

always@(*)begin
if (regWrite)begin
loads = 0;
loads[Writereg] = 1;
end
else begin
loads = 0;
end
end

assign ReadData1 = registers[Readreg1];
assign ReadData2 = registers[Readreg2];


NBitReg n2(clk, 1'b0 , rst, 32'd0 ,  registers[0]);
genvar i;
generate
for(i=1;i<32;i=i+1)
begin : block
NBitReg n1(clk, loads[i], rst, Writedata ,  registers[i] );
end
endgenerate 



endmodule
