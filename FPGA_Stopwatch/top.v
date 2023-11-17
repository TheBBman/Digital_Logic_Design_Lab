module top_level(
    input clk,            // Main clock signal
    input pause,
    input rst,            // Reset signal
    input select,
    input adjust,
    output [6:0] seg,     // 7-segment display segments
    output [3:0] an       // 7-segment display anode signals
);

  	wire clk_2Hz;
  	wire clk_500Hz;	
  	wire clk_5Hz;
  	wire clk_10Hz;
  	
  	wire [5:0] minutes;
  	wire [5:0] seconds;

    // Instantiate the clock divider
    clock_divider clk_div(
        .clk(clk),
      	.rst(rst),
      	.clk_2Hz(clk_2Hz),
        .clk_5Hz(clk_5Hz),
        .clk_10Hz(clk_10Hz),
      	.clk_500Hz(clk_500Hz)
    );

    // Instantiate the display module
    display disp(
        .minutes(minutes),
        .seconds(seconds),
        .clk_500Hz(clk_500Hz),
        .clk_5Hz(clk_5Hz),
        .rst(rst),
        .select(select),
        .adjust(adjust),
        .seg(seg),
        .an(an)
    );
    
    stopwatch stop(
        .rst(rst),
        .pause(pause),
        .select(select),
        .adjust(adjust),
        .clk_2Hz(clk_2Hz),
        .clk_10Hz(clk_10Hz),
        .seconds(seconds),
        .minutes(minutes)
    );

endmodule