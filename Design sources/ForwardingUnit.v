`timescale 1ns / 1ps

module ForwardingUnit(input [4:0] ID_EX_RegisterRs1, ID_EX_RegisterRs2,  MEM_WB_RegisterRd, input
  MEM_WB_RegWrite , output reg forwardA, forwardB   );

always@(*)begin
if (( MEM_WB_RegWrite == 1 && (MEM_WB_RegisterRd != 0)
&& (MEM_WB_RegisterRd == ID_EX_RegisterRs1) ))  // forward from memwb
    forwardA = 1;
else forwardA = 0;

if (( MEM_WB_RegWrite == 1 && (MEM_WB_RegisterRd != 0)
&& (MEM_WB_RegisterRd == ID_EX_RegisterRs2) ))  // forward from memwb
    forwardB = 1;
else forwardB = 0;

end
endmodule
