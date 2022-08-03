`timescale 1ns / 1ps
module Topmodule(input rclk, clk, rst, input [1:0]ledSel, input [3:0] ssdSel, output [15:0] leds, output [3:0] Anode, output [6:0] LED_out);
wire [12:0] ssd;
Four_Digit_Seven_Segment_Driver_Optimized SSD1(clk,ssd,Anode,LED_out);
//DataPath DP(rclk, clk, rst, ledSel, ssdSel, leds,  ssd );
datapath dp( .clk(rclk), .rst(rst),/*Testing*/ .ledSel(ledSel), .ssdSel(ssdSel), .leds(leds), .ssd(ssd));

endmodule
