`include "defines.v"

module datapath(input clk, rst,/*Testing*/ input [1:0]ledSel, input [3:0] ssdSel, output reg [15:0] leds, output reg [12:0] ssd );
reg loadforpc;
wire [31:0] PCin, PCout, PC4out, ShiftLeftout, TAout, Instruction, Immout, WriteinReg, ReadData1, ReadData2, ALUin1, ALUin2, ALUout, TAin, Memout, forwardaout, forwardbout;
wire  MemRead, MemWrite, ALUSrc1, ALUSrc2, RegWrite, cf, zf, vf, sf, Sign, jalins,  ls, Itype, forwardA, forwardB;
wire [1:0] ALUOP, type, WriteregSel;
wire [1:0] branch_signal, branchMUX;
wire [3:0] ALUSel; 
reg [4:0] shamt;
wire [11:0] memaddr;
wire nclk;
assign nclk = ~clk;

//IF/ID
wire [31:0] IF_ID_PC, IF_ID_Inst, IF_ID_PC4out;
//ID/EX  +9
wire [31:0] ID_EX_PC, ID_EX_PC4, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, IF_ID_Inst_beforemux, ID_EX_Inst;
wire [10:0] ID_EX_Ctrl, ID_EX_Ctrlin;//branch_signal, MemRead, WriteregSel, MemWrite, ALUSrc1, ALUSrc2, RegWrite,Itype, ls  +5
wire [3:0] ID_EX_ALUSel;
//EX/MEM
wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Inst, EX_MEM_PC4, EX_MEM_Imm;
wire [6:0] EX_MEM_Ctrl, EX_MEM_Ctrlin; // branch Memread Memtoreg memwrite Regwrite 
wire [4:0] EX_MEM_Rd;
wire [3:0] EX_MEM_Flags;
wire [2:0] EX_MEM_TypeSign;
//MEM/WB
wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Inst, MEM_WB_Imm, MEM_WB_PC4;
wire [2:0] MEM_WB_Ctrl;//  memtoreg regwrite
wire [4:0] MEM_WB_Rd;
//IF_ID
NBitReg #(96) IF_ID1(.clk(nclk), .load(1'b1), .rst(rst), .D({PCout,PC4out, Memout}), .Q({IF_ID_PC, IF_ID_PC4out ,IF_ID_Inst_beforemux}));

//ID_EX
NBitReg #(207) ID_EX(.clk(clk), .load(1'b1), .rst(rst), 
.D({ID_EX_Ctrlin, IF_ID_PC, IF_ID_PC4out, ALUSel,ReadData1, ReadData2, Immout, IF_ID_Inst}), 
.Q({ID_EX_Ctrl, ID_EX_PC, ID_EX_PC4, ID_EX_ALUSel, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_Inst }));
//ID_EX_Ctrl =  branch_signal, MemRead, WriteregSel, MemWrite, ALUSrc1, ALUSrc2, RegWrite, Itype ls  +3

//EX_MEM
NBitReg #(206) EX_MEM(.clk(nclk), .load(1'b1), .rst(rst), 
.D({EX_MEM_Ctrlin/*regwrite*/ , TAout, cf, zf, vf, sf, ALUout, forwardbout, ID_EX_Inst, ID_EX_PC4, ID_EX_Imm, type, Sign  }), 
.Q({EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_Flags, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Inst, EX_MEM_PC4, EX_MEM_Imm, EX_MEM_TypeSign} ));
//EX_MEM_Ctrl= branch, MemRead, WriteregSel, MemWrite,RegWrite 
// EX_MEM_Flags = cf,zf,vf,sf

//MEM_WB
NBitReg #(163) MEM_WB(.clk(clk), .load(1'b1), .rst(rst), 
.D({EX_MEM_Ctrl[3:2], EX_MEM_Ctrl[0], Memout,EX_MEM_ALU_out, EX_MEM_Inst, EX_MEM_Imm, EX_MEM_PC4}), 
.Q({MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Inst, MEM_WB_Imm, MEM_WB_PC4}));

initial loadforpc = 1;

always@(*) begin
    if (clk) begin
    if((Memout[6:0] == 7'b1110011)&& (Memout[20]== 1'b1))
        loadforpc = 0;
    else
        loadforpc = 1;
    end
end


NBitReg PC(.clk(clk), .load(loadforpc), .rst(rst), .D(PCin), .Q(PCout));
RCA PC4(.A(PCout),.B(32'd4), .num(PC4out));
RCA TAA(.A(ID_EX_PC),.B(ID_EX_Imm), .num(TAout));
MUX4 NewPC(.A(PC4out), .B(EX_MEM_BranchAddOut), .C(EX_MEM_ALU_out), .D(0), .sel(branchMUX), .Out(PCin));
wire [7:0] mem0;
memory mem1(.clk(clk), .MemRead(EX_MEM_Ctrl[4]),  .MemWrite(EX_MEM_Ctrl[1]), .Sign(EX_MEM_TypeSign[0]), .addr(memaddr), .data_in(EX_MEM_RegR2), .type(EX_MEM_TypeSign[2:1]), .data_out(Memout));
MUX #(12)memoryin(.A(EX_MEM_ALU_out[11:0]), .B(PCout[11:0]), .sel(clk), .C(memaddr));
//InstMem IM(.addr(PCout[11:0]), .data_out(Memout));
rv32_ImmGen IG(.Imm(Immout), .IR(IF_ID_Inst));
CU Control(.OPCODE(IF_ID_Inst[`IR_opcode]), .ALUOP(ALUOP), .Writeregsel(WriteregSel), .Itype(Itype), .jalins(jalins), .MemRead(MemRead), .MemWrite(MemWrite), .ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), .RegWrite(RegWrite), .ls(ls), .branch(branch_signal));
DataMemCU DMCU(.ls(ID_EX_Ctrl[0]), .funct3(ID_EX_Inst[`IR_funct3]), .type(type), .Sign(Sign));
RegisterFile RF(.Readreg1(IF_ID_Inst[`IR_rs1]), .Readreg2(IF_ID_Inst[`IR_rs2]), .Writereg(MEM_WB_Inst[`IR_rd]), .regWrite(MEM_WB_Ctrl[0]), .clk(nclk), .rst(rst),  .Writedata(WriteinReg), .ReadData1(ReadData1), .ReadData2(ReadData2) );
MUX ALUinput(.A(forwardaout), .B(ID_EX_PC), .sel(ID_EX_Ctrl[4]), .C(ALUin1));
MUX ALUinput2(.A(forwardbout), .B(ID_EX_Imm), .sel(ID_EX_Ctrl[3]), .C(ALUin2));
prv32_ALU ALU(.a(ALUin1), .b(ALUin2), .shamt(ID_EX_Inst[`IR_shamt]), .r(ALUout), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .alufn(ID_EX_ALUSel), .Itype(ID_EX_Ctrl[1]));
//DataMem DM(.clk(clk), .MemRead(EX_MEM_Ctrl[4]), .MemWrite(EX_MEM_Ctrl[1]), .Sign(EX_MEM_TypeSign[0]), .addr(EX_MEM_ALU_out[11:0]), .data_in(EX_MEM_RegR2), .type(EX_MEM_TypeSign[1:0]), .data_out(Memout));
MUX4 FO(.A(MEM_WB_Mem_out), .B(MEM_WB_ALU_out), .C(MEM_WB_PC4), .D(MEM_WB_Imm), .sel(MEM_WB_Ctrl[2:1]), .Out(WriteinReg));
branchdecoder bd(.branch_signal(EX_MEM_Ctrl[6:5]), .funct3(EX_MEM_Inst[`IR_funct3]), .cf(EX_MEM_Flags[3]), .zf(EX_MEM_Flags[2]), .vf(EX_MEM_Flags[1]), .sf(EX_MEM_Flags[0]), .outSel(branchMUX));
ALUCU ControlALU(.ALUOP(ALUOP), .funct3(IF_ID_Inst[`IR_funct3]), .funct7(IF_ID_Inst[`IR_funct7]),.Itype(Itype), .ALUSel(ALUSel));

ForwardingUnit fu(.ID_EX_RegisterRs1(ID_EX_Inst[`IR_rs1]), .ID_EX_RegisterRs2( ID_EX_Inst[`IR_rs2]),  .MEM_WB_RegisterRd(MEM_WB_Inst[`IR_rd]), 
  .MEM_WB_RegWrite( MEM_WB_Ctrl[0]), .forwardA(forwardA), .forwardB(forwardB));
MUX fwdamux(.A(ID_EX_RegR1), .B(WriteinReg), .sel(forwardA), .C(forwardaout));
MUX fwdbmux(.A(ID_EX_RegR2), .B(WriteinReg), .sel(forwardB), .C(forwardbout));
//MUX4 fwdamux(.A(ID_EX_RegR1), .B(Finalout), .C(EX_MEM_ALU_out), .D(0), .sel(forwardA), .Out(ALU1stinput));
//MUX4 fwdbmux(.A(ID_EX_RegR2), .B(Finalout), .C(EX_MEM_ALU_out), .D(0), .sel(forwardB), .Out(forward2out));
assign flushsel = (branchMUX != 0);
MUX flushifid(.A(IF_ID_Inst_beforemux), .B(32'h00000013), .sel(flushsel), .C(IF_ID_Inst));
MUX #(11)flushidex(.A({branch_signal, MemRead, WriteregSel, MemWrite, ALUSrc1, ALUSrc2, RegWrite, Itype, ls}), 
.B(11'd0), .sel(flushsel), .C(ID_EX_Ctrlin));
MUX flushexmem(.A({ID_EX_Ctrl[10:5], ID_EX_Ctrl[2]}), .B(7'd0), .sel(flushsel), .C(EX_MEM_Ctrlin));


/*Testing*/

always@(*) begin
    case(ledSel)
    2'b00: leds = Memout[15:0];
    2'b01: leds = Memout[31:16];
//    2'b10: leds = {2'b0,branchMUX, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ZeroFlag, branch, ALUOP, ALUSel};
    default: leds = 0;
    endcase
end

always@(*) begin
    case(ssdSel)
    4'b0000: ssd = PCout[12:0];
    4'b0001: ssd = PC4out[12:0];
    4'b0010: ssd = TAout[12:0];
    4'b0011: ssd = PCin[12:0];
    4'b0100: ssd = ReadData1[12:0];
    4'b0101: ssd = ReadData2[12:0];
    4'b0110: ssd = WriteinReg[12:0];
    4'b0111: ssd = Immout[12:0];
    4'b1000: ssd = ShiftLeftout[12:0];
    4'b1001: ssd = ALUin2[12:0];
    4'b1010: ssd = ALUout[12:0];
    4'b1011: ssd = Memout[12:0];
    4'b1100: ssd = MEM_WB_Mem_out;
    4'b1101: ssd = MEM_WB_Ctrl[2:1];
    default: ssd = 0;
    endcase
end



endmodule