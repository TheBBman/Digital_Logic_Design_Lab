module display(
    input [12:0] number,  // 14 bits for up to 9999
    input clk_500Hz,      // Clock signal for multiplexing
    input clk_5Hz,
    input rst,
    input select,         // Game state
    input mode,           // Select mode (easy, regular, hard)
    output reg [6:0] seg, // Segments including DP (active low)
    output reg [3:0] an   // Anodes (active low)
);
    // Internal signals for each digit
    wire [3:0] dig_3, dig_2, dig_1, dig_0;
    
    // Assign each pair of digits
    assign dig_3 = number / 1000;        // Leftmost digit
    assign dig_2 = (number / 100) % 10;
    assign dig_1 = (number / 10) % 10;
    assign dig_0 = number % 10;

    // 2-bit counter to cycle through the digits
    reg [1:0] digit_counter = 2'b00;

    // Letters
    reg [6:0] E = 7'b0000110; // E
    reg [6:0] A = 7'b0001000; // A
    reg [6:0] S = 7'b0010010; // S
    reg [6:0] Y = 7'b0011001; // Y
    reg [6:0] r = 7'b0101111; // r
    reg [6:0] g = 7'b0010000; // g
    reg [6:0] U = 7'b1000001; // U
    reg [6:0] H = 7'b0001001; // H
    reg [6:0] d = 7'b0100001; // d

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
        end 
        else begin
            digit_counter <= digit_counter + 1;

            if (select == 0) begin
                if (mode == 2'b00) begin        // Easy
                    case(digit_counter)
                        2'b00: begin
                            seg <= E;
                            an <= 4'b1110;
                        end
                        2'b01: begin
                            seg <= A;
                            an <= 4'b1101;
                        end
                        2'b10: begin
                            seg <= S;
                            an <= 4'b1011;
                        end
                        2'b11: begin
                            seg <= Y;
                            an <= 4'b0111;
                        end
                    endcase
                end 
                else if (mode == 2'b01) begin   // Medium
                    case(digit_counter)
                        2'b00: begin
                            seg <= r;
                            an <= 4'b1110;
                        end
                        2'b01: begin
                            seg <= E;
                            an <= 4'b1101;
                        end
                        2'b10: begin
                            seg <= g;
                            an <= 4'b1011;
                        end
                        2'b11: begin
                            seg <= U;
                            an <= 4'b0111;
                        end
                    endcase
                end
                else if (mode == 2'b10) begin                  // Hard
                    case(digit_counter)
                        2'b00: begin
                            seg <= H;
                            an <= 4'b1110;
                        end
                        2'b01: begin
                            seg <= A;
                            an <= 4'b1101;
                        end
                        2'b10: begin
                            seg <= r;
                            an <= 4'b1011;
                        end
                        2'b11: begin
                            seg <= d;
                            an <= 4'b0111;
                        end
                    endcase
                end
            end
            else if (select == 1) begin
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
    end

endmodule