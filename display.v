module display(
    input [7:0] minutes,  // 8 bits for minutes (00-59)
    input [7:0] seconds,  // 8 bits for seconds (00-59)
    input clk_500Hz,      // Clock signal for multiplexing
    output reg [7:0] seg, // Segments including DP (active low)
    output reg [3:0] an   // Anodes (active low)
);

    // Internal signals for each digit
    wire [3:0] min_tens, min_ones, sec_tens, sec_ones;
    
    // Assign each pair of digits
    assign min_tens = minutes / 10;
    assign min_ones = minutes % 10;
    assign sec_tens = seconds / 10;
    assign sec_ones = seconds % 10;

    // 2-bit counter to cycle through the digits
    reg [1:0] digit_counter = 2'b00;

    // Segment decoding (active low for common anode)
    function [7:0] decode_seg;
        input [3:0] digit;
        case (digit)
            4'h0: decode_seg = 8'b11000000;
            4'h1: decode_seg = 8'b11111001;
            4'h2: decode_seg = 8'b10100100;
            4'h3: decode_seg = 8'b10110000;
            4'h4: decode_seg = 8'b10011001;
            4'h5: decode_seg = 8'b10010010;
            4'h6: decode_seg = 8'b10000010;
            4'h7: decode_seg = 8'b11111000;
            4'h8: decode_seg = 8'b10000000;
            4'h9: decode_seg = 8'b10010000;
            default: decode_seg = 8'b11111111; // Off
        endcase
    endfunction

    // On every clock cycle, update the digit to display
    always @(posedge clk_500Hz) begin
        digit_counter <= digit_counter + 1;
        
        case(digit_counter)
            2'b00: begin
                seg <= decode_seg(min_tens); // Tens of minutes
                an <= 4'b1110; // Activate first digit
            end
            2'b01: begin
                seg <= decode_seg(min_ones); // Ones of minutes
                an <= 4'b1101; // Activate second digit
            end
            2'b10: begin
                seg <= decode_seg(sec_tens); // Tens of seconds
                an <= 4'b1011; // Activate third digit
            end
            2'b11: begin
                seg <= decode_seg(sec_ones); // Ones of seconds
                an <= 4'b0111; // Activate fourth digit
            end
        endcase
    end

endmodule