module top_level(
    input clk,            // Main clock signal
    input rst,            // Reset signal
    input btnU,
    input btnS,
    input btnD,
    // Define button inputs here
    output [6:0] seg,     // 7-segment display segments
    output [3:0] an,       // 7-segment display anode signals
    output [15:0] led
);

  	wire clk_2Hz;
  	wire clk_500Hz;	
  	wire clk_5Hz;
  	wire clk_20Hz;
    wire [1:0] select;
    wire [1:0] mode;
    wire [13:0] number;
    wire [13:0] rand;
  	
  	// wire [13:0] number;

    logic log(
        .clk(clk),
        .rst(rst),
        .btnU(btnU),
        .btnS(btnS),
        .btnD(btnD),
        .select(select),
        .rand(rand),
        .clk_20Hz(clk_20Hz),
        .mode(mode),
        .number(number),
        .led(led)
    );

    // Instantiate the clock divider
    clock_divider clk_div(
        .clk(clk),
      	.rst(rst),
      	.clk_2Hz(clk_2Hz),
        .clk_5Hz(clk_5Hz),
        .clk_20Hz(clk_20Hz),
      	.clk_500Hz(clk_500Hz)
    );

    // Instantiate the display module
    display disp(
        .number(number),
        .clk_500Hz(clk_500Hz),
        .clk_5Hz(clk_5Hz),
        .rst(rst),
        .select(select),
        .mode(mode),
        .seg(seg),
        .an(an)
    );

    LFSR random(
        .clk(clk),
        .rst(rst),
        .rand(rand)
    );

endmodule