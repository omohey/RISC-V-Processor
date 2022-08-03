// file: datapath_tb.v
// author: @omarmohey
// Testbench for datapath

`timescale 1ns/1ns

module datapath_tb;
	// Declarations
	reg  rst;
	reg  clk;

	// Instantiation of Unit Under Test
	datapath uut (
		.rst(rst),
		.clk(clk)
	);

always #10 clk = !clk;
	initial begin
		// Input Initialization
		rst = 0;
		clk = 0;
		#1;
		rst = 1;
		#1;
		rst = 0;

		// Reset
		#100;
	end

endmodule