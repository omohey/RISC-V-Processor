`timescale 1ns / 1ps
module MUX #(parameter n = 32)(input [n-1:0] A, B,input sel, output [n-1:0] C);


assign C = (sel == 1'b1) ? B : A;

endmodule


module MUX_bit #(parameter n = 1)(input [n-1:0] A, B,input sel, output [n-1:0] C);


assign C = (sel == 1'b1) ? B : A;

endmodule
