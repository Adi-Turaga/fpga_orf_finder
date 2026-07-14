`timescale 1ns / 1ps

module third_base_rom(
    input [3:0] first2,
    input purine, 
    output logic [4:0] amino_out,
    output logic tbr_valid
    );
    
    // A: 0b00
    // U: 0b01
    // G: 0b10
    // C: 0b11
    
    always_comb begin
        amino_out = 5'b11000;
        tbr_valid = 1'b1;
        
        case(first2)
            4'b0101: begin
                case(purine)
                    1'b1: amino_out = 5'b00011; // Leucine
                    1'b0: amino_out = 5'b00111; // Phenylalanine
                endcase
            end
            4'b1100: begin
                case(purine)
                    1'b1: amino_out = 5'b01110; // Glutamine
                    1'b0: amino_out = 5'b10011; // Histidine
                endcase
            end
            4'b0000: begin
                case(purine)
                    1'b1: amino_out = 5'b10001; // Lysine
                    1'b0: amino_out = 5'b01101; // Asparagine
                endcase
            end
            4'b1000: begin
                case(purine)
                    1'b1: amino_out = 5'b10000; // Glutamic Acid
                    1'b0: amino_out = 5'b01111; // Aspartic Acid
                endcase
            end
            4'b0010: begin
                case(purine)
                    1'b1: amino_out = 5'b10010; // Arginine
                    1'b0: amino_out = 5'b01010; // Serine
                endcase
            end  
            default: tbr_valid = 1'b0;                                  
        endcase
    end
    
endmodule
