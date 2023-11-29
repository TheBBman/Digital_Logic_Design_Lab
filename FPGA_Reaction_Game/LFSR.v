module LFSR(
    input clk,
    input rst,
    output [13:0] rand
);

reg [31:0] LFSR;
wire xNOR;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        LFSR <= 673641282;
    end else begin
        LFSR <= {LFSR[30:0], xNOR};
    end
end

assign rand = LFSR[13:0];
assign xNOR = LFSR[32]^~LFSR[22]^~LFSR[2]^~LFSR[1];

endmodule