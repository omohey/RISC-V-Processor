`include "defines.v"
module CU(input [4:0]OPCODE,  output reg [1:0] ALUOP, output reg [1:0] Writeregsel, output reg Itype, jalins, MemRead, MemWrite, ALUSrc1, ALUSrc2, RegWrite, ls, output reg [1:0] branch);


always@(*)begin
    Itype = 0;
    ls = 0;
    case(OPCODE)
    `OPCODE_Branch: begin
        ALUOP = 2'b01;
        branch = 1;
        Writeregsel = 0;
        MemRead = 0;
        MemWrite = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 0;
        RegWrite = 0;
        jalins = 0;
    end
    `OPCODE_Load: begin
        ALUOP = 2'b00;
        branch = 0;
        Writeregsel = 0;
        MemRead = 1;
        MemWrite = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 1;
        RegWrite = 1;
        jalins = 0;
        ls = 1;
    end
    `OPCODE_Store: begin
        ALUOP = 2'b00;
        branch = 0;
        Writeregsel = 0;
        MemRead = 0;
        MemWrite = 1;
        ALUSrc1 = 0;
        ALUSrc2 = 1;
        RegWrite = 0;
        jalins = 0;
        ls = 1;
    end
    `OPCODE_JALR: begin 
        ALUOP = 2'b00;
        branch = 3;
        Writeregsel = 2;
        MemRead = 0;
        MemWrite = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 1;
        RegWrite = 1;
        jalins = 1;
    end
    `OPCODE_JAL: begin
        ALUOP = 2'b11;
        branch = 2;
        Writeregsel = 2;
        MemRead = 0;
        MemWrite = 0;
        ALUSrc1 = 1;
        ALUSrc2 = 1;
        RegWrite = 1;
        jalins = 1;
    end
    `OPCODE_Arith_I: begin
        ALUOP = 2'b10;
        branch = 0;
        Writeregsel = 1;
        MemRead = 0;
        MemWrite = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 1;
        RegWrite = 1;
        jalins = 0;
        Itype = 1;
        end
    `OPCODE_Arith_R: begin
        ALUOP = 2'b10;
        branch = 0;
        Writeregsel = 1;
        MemRead = 0;
        MemWrite = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 0;
        RegWrite = 1;
        jalins = 0;
    end
    `OPCODE_AUIPC: begin
        ALUOP = 2'b00;
        branch = 0;
        Writeregsel = 1;
        MemRead = 0;
        MemWrite = 0;
        ALUSrc1 = 1;
        ALUSrc2 = 1;
        RegWrite = 1;
        jalins = 0;
    end
    `OPCODE_LUI: begin
        ALUOP = 2'b11;
        branch = 0;
        Writeregsel = 3;
        MemRead = 0;
        MemWrite = 0;
        ALUSrc1 = 0;
        ALUSrc2 = 0;
        RegWrite = 1;
        jalins = 0;
    end
    `OPCODE_SYSTEM: begin 
        ALUOP = 2'b00;
        {Writeregsel, MemRead, MemWrite, ALUSrc1, ALUSrc2, RegWrite, branch} =0; 
    end
    5'b00011: begin
      ALUOP = 2'b00;
      {Writeregsel, MemRead, MemWrite, ALUSrc1, ALUSrc2, RegWrite, branch} =0;
    end
    `OPCODE_Custom: ALUOP = 2'b00;
    default: ALUOP = 2'b11;
    endcase
end

//always@(*)begin
//    if(OPCODE == `OPCODE_Load || OPCODE == `OPCODE_Store)begin
//        ls = 1;
//    end
//    else
//      ls = 0;
//end


endmodule