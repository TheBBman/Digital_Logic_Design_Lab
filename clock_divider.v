// Provides different clock frequencies

module clock_divider(
    input clk,            // Master clock input, 100MHz
    input rst,            // Reset signal
    output reg clk_1Hz,   // 1Hz clock output
    output reg clk_2Hz,   // 2Hz clock output
    output reg clk_5Hz,    // 5Hz flashing clock
    output reg clk_500Hz  // 500Hz clock output
);

reg [26:0] counter_1Hz = 0;
reg [26:0] counter_2Hz = 0;
reg [26:0] counter_5Hz = 0;
reg [16:0] counter_500Hz = 0;

//initial begin
//    clk_1Hz <= 0;
//    clk_2Hz <= 0;
//    clk_5Hz <= 0;
//    clk_500Hz <= 0;
//end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter_1Hz <= 0;
        counter_2Hz <= 0;
        counter_500Hz <= 0;
        clk_1Hz <= 0;
        clk_2Hz <= 0;
        clk_5Hz <= 0;
        clk_500Hz <= 0;

    end else begin
        // Generate 1Hz clock
        if (counter_1Hz == 49999999) begin
            counter_1Hz <= 0;
            clk_1Hz <= ~clk_1Hz;
        end else begin
            counter_1Hz <= counter_1Hz + 1;
        end

        // Generate 2Hz clock
        if (counter_2Hz == 24999999) begin
            counter_2Hz <= 0;
            clk_2Hz <= ~clk_2Hz;
        end else begin
            counter_2Hz <= counter_2Hz + 1;
        end

        // Generate 5Hz clock
        if (counter_5Hz == 9999999) begin
            counter_5Hz <= 0;
            clk_5Hz <= ~clk_5Hz;
        end else begin
            counter_5Hz <= counter_5Hz + 1;
        end

        // Generate 500Hz clock
        if (counter_500Hz == 99999) begin
            counter_500Hz <= 0;
            clk_500Hz <= ~clk_500Hz;
        end else begin
            counter_500Hz <= counter_500Hz + 1;
        end
    end
end

endmodule