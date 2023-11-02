module display(
    input [7:0] minutes,  // 8 bits for minutes (00-59)
    input [7:0] seconds,  // 8 bits for seconds (00-59)
    input clk_500Hz,      // Clock signal for multiplexing
    output reg [6:0] seg, // Segments including DP (active low)
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
    function [6:0] decode_seg;
        input [3:0] digit;
        case (digit)
            4'h0: decode_seg = 7'b0000001; // 0
            4'h1: decode_seg = 7'b1001111; // 1
            4'h2: decode_seg = 7'b0010010; // 2
            4'h3: decode_seg = 7'b0000110; // 3
            4'h4: decode_seg = 7'b1001100; // 4
            4'h5: decode_seg = 7'b0100100; // 5
            4'h6: decode_seg = 7'b0100000; // 6
            4'h7: decode_seg = 7'b0001111; // 7
            4'h8: decode_seg = 7'b0000000; // 8
            4'h9: decode_seg = 7'b0000100; // 9
            default: decode_seg = 7'b1111111; // Off
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