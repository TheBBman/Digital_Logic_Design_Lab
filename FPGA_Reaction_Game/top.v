module top_level(
    input clk,            // Main clock signal
    input rst,            // Reset signal
    input [12:0] number,
    input select,
    input btnU,
    input btnS,
    input btnD,
    // Define button inputs here
    output [6:0] seg,     // 7-segment display segments
    output [3:0] an       // 7-segment display anode signals
);

  	wire clk_2Hz;
  	wire clk_500Hz;	
  	wire clk_5Hz;
  	wire clk_10Hz;
  	
  	// wire [13:0] number;

    logic log(
        .clk(clk),
        .clk_10Hz(clk_10Hz),
        .rst(rst),
        .btnU(btnU),
        .btnS(btnS),
        .btnD(btnD),
        .select(select),
        .mode(mode)
    );

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
        .number(number),
        .clk_500Hz(clk_500Hz),
        .clk_5Hz(clk_5Hz),
        .rst(rst),
        .select(select),
        .mode(mode),
        .seg(seg),
        .an(an)
    );

endmodule