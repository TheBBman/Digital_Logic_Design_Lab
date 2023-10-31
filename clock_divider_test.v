module clock_divder_test;

	reg clk;
	reg rst;

  	wire clk_1Hz;
  	wire clk_2Hz;
  	wire clk_500Hz;	
  	wire clk_5Hz;
  
	clock_divider uut (
		.clk(clk),
      	.rst(rst),
      	.clk_1Hz(clk_1Hz),
      	.clk_2Hz(clk_2Hz),
      	.clk_500Hz(clk_500Hz),
      	.clk_5Hz(clk_5Hz)
	);

	initial begin
		clk = 0;
		rst = 0;
	end

	always #5 clk = ~clk;

endmodule