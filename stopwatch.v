module stopwatch (
    input rst,           // Asynchronous reset
    input pause,        // Pause counter
    input select,       // 0: minutes, 1: seconds
    input adjust,       // 0: stopwatch behaves normally, 1: sel increases at 2Hz

    input clk_2Hz,           // 2Hz clock
    input clk_10Hz,

    output reg [5:0] seconds,     // 0 to 59
    output reg [5:0] minutes     // 0 to 59
);

reg pause_signal;
reg paused;
reg [0:0] clk_1Hz;

always @(posedge clk_10Hz or posedge rst) begin 
    if (rst) begin
        pause_signal = 0;
        paused = 0;
    end
    else begin
        if (~paused && pause) begin
            pause_signal = ~pause_signal;
            paused = 1;
        end else begin
            if (paused && ~pause) 
                paused = 0;
        end
    end
end

always @(posedge clk_2Hz or posedge rst) begin
    if (rst) begin 
        seconds <= 0;
        minutes <= 0;
        clk_1Hz <= 0;  
    end else begin
        clk_1Hz <= clk_1Hz + 1;
        if (~adjust && ~pause_signal && clk_1Hz) begin
            if (seconds < 59)
                seconds <= seconds + 1;
            else begin
                seconds <= 0;
                if (minutes < 59)
                    minutes <= minutes + 1;
                else
                    minutes <= 0;
            end
        end

        if (adjust) begin
            if (select) begin
                if (minutes < 59)
                    minutes <= minutes + 1;
                else
                    minutes <= 0;
            end else begin  
                if (seconds < 59)
                    seconds <= seconds + 1;
                else
                    seconds <= 0;
            end
        end
    end
end

endmodule