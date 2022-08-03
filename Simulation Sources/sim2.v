`timescale 1ns / 1ps

module sim2();

	reg  rst;
	reg  clk, rclk;
	reg [1:0]ledSel;
	reg [3:0] ssdSel;
	wire [15:0] leds;
	wire [3:0] Anode;
	wire [6:0] LED_out;
	
    
Topmodule uut(rclk, clk, rst, ledSel,  ssdSel,leds, Anode, LED_out);

always #10 rclk = !rclk;
always #1 clk = !clk;
	initial begin
		// Input Initialization
		rst = 0;
		clk= 0;
		rclk = 0;
		{ssdSel, ledSel} = 0;
		#1;
		ledSel = 1;
		ssdSel = 6;
		rst = 1;
		#1;
		ledSel = 0;
		rst = 0;

		// Reset
		#100;
	end

endmodule
