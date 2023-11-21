module display(
    input [13:0] number,  // 14 bits for up to 9999
    input clk_500Hz,      // Clock signal for multiplexing
    input clk_5Hz,
    input rst,
    input select,
    output reg [6:0] seg, // Segments including DP (active low)
    output reg [3:0] an   // Anodes (active low)
);
    // Internal signals for each digit
    wire [3:0] min_tens, min_ones, sec_tens, sec_ones;
    
    // Assign each pair of digits
    assign dig_3 = number / 1000;        // Leftmost digit
    assign dig_2 = (number / 100) % 10;
    assign dig_1 = (number / 10) % 10;
    assign dig_0 = number % 10;

    // 2-bit counter to cycle through the digits
    reg [1:0] digit_counter = 2'b00;

    // Letters
    letter_E = 7'b1111001; // E
    letter_A = 7'b1110111; // A
    letter_S = 7'b1101101; // S
    letter_Y = 7'b1100110; // Y
    letter_r = 7'b1010000; // r
    letter_g = 7'b1101111; // g
    letter_U = 7'b0111110; // U
    letter_H = 7'b0111110; // H
    letter_d = 7'b1011110; // d

    // Segment decoding (active low for common anode)
    function [6:0] decode_seg;
        input [3:0] digit;
        
        case (digit)
            4'h0: decode_seg = 7'b1000000; // 0
            4'h1: decode_seg = 7'b1111001; // 1
            4'h2: decode_seg = 7'b0100100; // 2
            4'h3: decode_seg = 7'b0110000; // 3
            4'h4: decode_seg = 7'b0011001; // 4
            4'h5: decode_seg = 7'b0010010; // 5
            4'h6: decode_seg = 7'b0000010; // 6
            4'h7: decode_seg = 7'b1111000; // 7
            4'h8: decode_seg = 7'b0000000; // 8
            4'h9: decode_seg = 7'b0011000; // 9
            default: decode_seg = 7'b1111111; // Off
        endcase
    endfunction

    // On every clock cycle, update the digit to display
    always @(posedge clk_500Hz or posedge rst) begin
        if (rst) begin
            an <= 4'b0000;
            seg <= 7'b1111111;
        end else begin
            digit_counter <= digit_counter + 1;
                  
            case(digit_counter)
                2'b00: begin
                    seg <= decode_seg(dig_3); 
                    an <= 4'b1110;
                end
                2'b01: begin
                    seg <= decode_seg(dig_2);
                    an <= 4'b1101;
                end
                2'b10: begin
                    seg <= decode_seg(dig_1);
                    an <= 4'b1011;
                end
                2'b11: begin
                    seg <= decode_seg(dig_0);
                    an <= 4'b0111;
                end
            endcase
        end
    end

endmodule