timescale 1ns / 1ps

module top_level(
    input clk,            // Main clock signal
    input rst,            // Reset signal
    input [7:0] minutes,  // Minutes input
    input [7:0] seconds,  // Seconds input
    output [7:0] seg,     // 7-segment display segments
    output [3:0] an       // 7-segment display anode signals
);

    wire clk_1Hz;
  	wire clk_2Hz;
  	wire clk_500Hz;	
  	wire clk_5Hz;

    // Instantiate the clock divider
    clock_divider clk_div(
        .clk(clk),
      	.rst(rst),
      	.clk_1Hz(clk_1Hz),
      	.clk_2Hz(clk_2Hz),
        .clk_5Hz(clk_5Hz),
      	.clk_500Hz(clk_500Hz)
    );

    // Instantiate the display module
    display disp(
        .minutes(minutes),
        .seconds(seconds),
        .clk_500Hz(clk_500Hz),
        .seg(seg),
        .an(an)
    );

endmodule