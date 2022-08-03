module branchdecoder(input [1:0] branch_signal, input [2:0] funct3, input cf, zf, vf, sf, output reg [1:0 ]outSel);
/*
** 0 --> not branch
** 1 --> branch 
** 2 --> jal
** 3 --> jalr
*/

/*
0 --> beq
1 --> bne
4 --> blt
5 --> bge
6 --> bltu
7 --> bgeu
*/
always@(*) begin
    case(branch_signal)
    0: outSel = 0;
    2: outSel = 1;
    3: outSel = 2;
    1: begin
    case(funct3)
    0: outSel = zf;
    1: outSel = !zf;
    4: outSel = (sf != vf) ? 1 : 0;
    5: outSel = (sf == vf) ? 1 : 0;
    6: outSel = (cf == 0) ? 1 : 0;
    7: outSel = (cf == 1) ? 1 : 0;
    
    endcase
    end
    default: outSel = 0;
    endcase
end


endmodule