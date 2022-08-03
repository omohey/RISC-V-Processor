module MUX4(input [n-1:0] A, B, C, D, input [1:0] sel, output reg [n-1:0] Out);
parameter n = 32;

always@(*)begin
    case(sel)
    0: Out = A;
    1: Out = B;
    2: Out = C;
    3: Out = D;
    endcase
end

endmodule