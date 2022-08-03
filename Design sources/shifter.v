module shifter (input [31:0] a, input [4:0] shamt, input [1:0] type, output reg [31:0]r);
integer i;

always@(*)begin
    r = a;
    for (i = 0; i < shamt; i = i +1)begin
        case(type)
        2'b00: r = { 1'b0, r[31:1]}; //SRL
        2'b01: r = {r[30:0],1'b0}; //SLL
        2'b10: r = { (r[31]==1) ? 1'b1 : 1'b0, r[31:1] };
        default: r = 0;
        endcase
    end
end

endmodule