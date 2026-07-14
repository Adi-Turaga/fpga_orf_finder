`timescale 1ns / 1ps

/* redundant ROM ("red rom") checks for fourfold degenerate sites
*/

module red_rom(
    input logic [3:0] first2,
    output logic [4:0] amino_out,
    output logic red_valid
    );
    
    // A: 0b00
    // U: 0b01
    // G: 0b10
    // C: 0b11
    
    always_comb begin    
        amino_out = 5'b11000;
        red_valid = 1'b1;
        
        case(first2)
            4'b1101: amino_out = 5'b00011; // Leucine
            4'b1001: amino_out = 5'b00010; // Valine
            4'b0111: amino_out = 5'b01010; // Serine
            4'b1111: amino_out = 5'b00101; // Proline
            4'b0011: amino_out = 5'b01011; // Threonine
            4'b1011: amino_out = 5'b00001; // Alanine
            4'b1110: amino_out = 5'b10010; // Arginine
            4'b1010: amino_out = 5'b00000; // Glycine
            default: red_valid = 1'b0;
        endcase
    end
    
endmodule
