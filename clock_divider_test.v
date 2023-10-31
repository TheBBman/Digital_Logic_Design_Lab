module clock_divder_test;

	reg clk;
	reg rst;

	clock_divider uut (
		.clk(clk),
		.rst(rst)
	);

	initial begin
		clk = 0;
		rst = 0;
	end

	always #5 clk = ~clk;

endmodule