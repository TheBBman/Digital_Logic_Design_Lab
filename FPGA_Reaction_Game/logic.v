module logic(
    input clk,
    input clk_10Hz,
    input rst,
    input btnU,
    input btnD,
    input btnS,
    output select,
    output reg mode[1:0],
);

reg btnU_lock;
reg btnS_lock;
reg btnD_lock;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        select = 0;
        mode = 1;
        btnU_lock = 0;
        btnS_lock = 0;
        btnD_lock = 0;
    end else begin
        if (select == 0) begin
            if (btnS) begin
                select = 1;
            end
            if (~btnU_lock && btnU) begin
                mode = (mode < 2) ? mode + 1 : mode;
                btnU_lock = 1;
            end
            if (btnU_lock && ~btnU) begin
                btnU_lock = 0;
            end
            if (~btnD_lock && btnD) begin
                mode = (mode > 0) ? mode - 1 : mode;
                btnD_lock = 1;
            end
            if (btnD_lock && ~btnU) begin
                btnD_lock = 0;
            end
        end
    end

end

endmodule