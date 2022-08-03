
module DataMemCU(input ls, input [2:0] funct3, output reg [1:0] type, output reg Sign);

always@(*)begin
    if(ls == 1)begin
        casex (funct3)
            3'bx00: type = 0;
            3'bx01: type = 1;
            3'b010: type = 2; 
            default: type =2;
        endcase
        if (funct3[2]==1)begin
            Sign = 0;
        end
        else begin
            Sign = 1;
        end
    end
end

endmodule