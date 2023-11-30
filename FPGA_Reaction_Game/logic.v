module logic(
    input clk,
    input rst,
    input btnU,
    input btnD,
    input btnS,
    input [13:0] rand,
    input clk_20Hz,
    output reg [1:0] select,
    output reg [1:0] mode,
    output reg [13:0] number,
    output reg [15:0] led
);

reg btnU_lock;
reg btnS_lock;
reg btnD_lock;

reg [13:0] current_rand;
reg [12:0] score;
reg [4:0] num_leds_off;

parameter easy_ticks =  1000000;
parameter reg_ticks =   200000;
parameter hard_ticks =  100000;

reg [19:0] tick_count;

always @(posedge clk_20Hz or posedge rst) begin
    // Select
    if (btnS && ~btnS_lock) begin
        btnS_lock <= 1;
        if (select == 0)
            select <= 1; // Random number mode
        else if (select == 1) begin
            select <= 2; // Counting mode
            number <= 0;
        end
        else if (select == 2)
            select <= 3; // Score calculation mode
    end
    if (~btnS && btnS_lock)
        btnS_lock <= 0;
    
    // Up
    if (btnU && ~btnU_lock) begin
        btnU_lock <= 1;
        if (select == 0) begin
            if (mode < 2)
                mode <= mode + 1;
        end
    end
    if (~btnU && btnU_lock)
        btnU_lock <= 0;

    // Down
    if (btnD && ~btnD_lock) begin
        btnD_lock <= 1;
        if (select == 0) begin
            if (mode > 0)
                mode <= mode - 1;
        end
    end
    if (~btnD && btnD_lock)
        btnD_lock <= 0;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        select <= 0;
        mode <= 1;
        led <= 0;
        btnU_lock <= 0;
        btnS_lock <= 0;
        btnD_lock <= 0;
        tick_count <= 0;
        current_rand <= 0;
        number <= 0;
    end else begin
        if (select == 1) begin
            if (current_rand == 0) begin
                current_rand = rand;
                number = current_rand;
            end
        end
        if (select == 2) begin
            number <= 0;
            tick_count <= tick_count + 1;
            if (mode == 0 && (tick_count == easy_ticks - 1)) begin
                number <= number + 1;
                tick_count <= 0;
            end
            if (mode == 1 && (tick_count == reg_ticks - 1)) begin
                number <= number + 1;
                tick_count <= 0;
            end
            if (mode == 2 && (tick_count == hard_ticks - 1)) begin
                number <= number + 1;
                tick_count <= 0;
            end
        end
        if (select == 3) begin
            if (number < current_rand)
                score <= current_rand - number;
            else 
                score <= number - current_rand;
            num_leds_off =  16;
            if (score < 490) begin
                num_leds_off = score/30;
                led = ~((1'b1 << num_leds_off) - 1'b1);
            end
        end
    end
end

endmodule