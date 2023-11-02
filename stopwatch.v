module stopwatch (
    input wire rst,       // Asynchronous reset
    input wire pause,     // Pause counter

    input wire sel,       // 0: minutes, 1: seconds
    input wire adj,       // 0: stopwatch behaves normally, 1: sel increases at 2Hz

    input wire clk_1Hz,   // 1Hz clock
    input wire clk_2Hz,   // 2Hz clock

    output [7:0] seconds,     // 0 to 59
    output [7:0] minutes,     // 0 to 59
);

reg [5:0] seconds_counter = 0;
reg [5:0] minutes_counter = 0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        seconds_counter <= 0;
        minutes_counter <= 0;

    end else begin
        // Stopwatch logic
        if (clk_1Hz) begin
            if (seconds_counter < 59) begin
                seconds_counter <= seconds_counter + 1;
            end else begin
                seconds_counter <= 0; // Seconds rollover
                if (minutes_counter < 59) begin
                    minutes_counter <= minutes_counter + 1;
                end else begin
                    minutes_counter <= 0; // Minutes rollover
                end
            end
        end
    end
end

assign seconds = seconds_counter;
assign minutes = minutes_counter;

endmodule
