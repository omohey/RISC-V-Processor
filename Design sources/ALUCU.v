`include "defines.v"

module ALUCU(input [1:0] ALUOP, input [2:0] funct3, input [6:0] funct7,input Itype ,output reg [3:0] ALUSel);

always@(*)begin
  case(ALUOP)
    2'b00: ALUSel = `ALU_ADD;
    2'b01: ALUSel = `ALU_SUB;
    2'b10: begin
      case(funct3)
        `F3_ADD: begin
            if (funct7[5] && !(Itype))begin
                ALUSel = `ALU_SUB;
            end
            else begin
                ALUSel = `ALU_ADD;
            end
          end
          `F3_SLL: ALUSel = `ALU_SLL;
          `F3_SLT: ALUSel = `ALU_SLT;
          `F3_SLTU: ALUSel = `ALU_SLTU;
          `F3_XOR: ALUSel = `ALU_XOR;
          `F3_OR: ALUSel = `ALU_OR;
          `F3_AND: ALUSel = `ALU_AND;
          `F3_SRL: begin
            if (funct7[5])begin
                ALUSel = `ALU_SRA;
            end
            else begin
                ALUSel = `ALU_SRL;
            end
          end
        endcase
    end
    2'b11: ALUSel = `ALU_PASS;
  endcase
end

endmodule