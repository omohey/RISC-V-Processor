`timescale 1ns / 1ps

module RCA(input [n-1:0] A,B, output [n:0] num);
parameter n = 32;


wire [n-2:0] Carry;
genvar i;
FullAdder m1(A[0],B[0],1'b0,num[0], Carry[0] );
generate 
    for (i=1; i<n-1; i = i+1)begin : add
    FullAdder m2(A[i],B[i],Carry[i-1],num[i], Carry[i] );
    end
    endgenerate
    FullAdder m3(A[n-1],B[n-1],Carry[n-2],num[n-1], num[n] );
    
endmodule