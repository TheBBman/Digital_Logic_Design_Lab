module logic(
    input clk,
    input rst,
    input btnU,
    input btnD,
    input btnS,
    output reg select,
    output reg [1:0] mode,
    output reg [13:0] number
);

reg btnU_lock;
reg btnS_lock;
reg btnD_lock;

parameter easy_ticks =  1000000;
parameter reg_ticks =   200000;
parameter hard_ticks =  100000;

reg [10:0] tick_count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        select <= 0;
        mode <= 1;
        btnU_lock <= 0;
        btnS_lock <= 0;
        btnD_lock <= 0;
        tick_count <= 0;
        number <= 0;
    end else begin
        if (select == 0) begin
            if (btnS) begin
                select <= 1;
            end
            if (~btnU_lock && btnU) begin
                if (mode < 2) begin
                    mode <= mode + 1;
                end
                btnU_lock <= 1;
            end
            if (btnU_lock && ~btnU) begin
                btnU_lock <= 0;
            end
            if (~btnD_lock && btnD) begin
                if (mode > 0) begin
                    mode <= mode - 1;
                end
                btnD_lock <= 1;
            end
            if (btnD_lock && ~btnD) begin
                btnD_lock <= 0;
            end
        end
        else if (select == 1) begin
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
    end

end

endmodule