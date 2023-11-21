module LFSR(
    input clk,
    input rst,
    output [13:0] rand
);

reg [31:0] LFSR;
reg xNOR;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        LSFR <= 673641282;
    end else begin
        LSFR <= {LSFR[30:0], xNOR};
    end
end

assign rand = LFSR[13:0];
assign xNOR = LSFR[32]^~LSFR[22]^~LSFR[2]^~LSFR[1];

endmodule