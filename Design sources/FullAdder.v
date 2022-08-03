`timescale 1ns / 1ps
module FullAdder(input A,B,Ci, output sum, co );

assign {co, sum} =A + B + Ci;

endmodule
