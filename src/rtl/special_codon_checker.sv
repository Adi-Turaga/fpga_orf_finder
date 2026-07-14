`timescale 1ns / 1ps
module special_codon_checker(
    input [5:0] codon_in,
    input purine,
    output logic [4:0] amino_out,
    output codon_pkg::codon_signals_t codon_signals,
    output logic scc_valid
    );
    
    // A: 0b00
    // U: 0b01
    // G: 0b10
    // C: 0b11
    // START CODON: AUG
    // STOP CODONS: UAA, UAG, UGA
    
    always_comb begin
        casez(codon_in)
            6'b0001??: begin
                case(codon_in[1:0])
                    2'b10: begin
                        amino_out = 5'b00110; // Methionine (START)
                        codon_signals.start = 1'b1; 
                        codon_signals.stop = 1'b0; 
                        scc_valid = 1'b1;
                    end
                    default: begin
                        amino_out = 5'b00100; // Isoleucine
                        codon_signals.start = 1'b0; 
                        codon_signals.stop = 1'b0; 
                        scc_valid = 1'b1;
                    end
                endcase
            end
            6'b0110??: begin 
                casez(codon_in[1:0])
                    2'b?1: begin
                        amino_out = 5'b01100; // Cystine
                        codon_signals.start = 1'b0; 
                        codon_signals.stop = 1'b0; 
                        scc_valid = 1'b1;
                    end
                    2'b00: begin
                        amino_out = 5'b11111; // STOP
                        codon_signals.start = 1'b0; 
                        codon_signals.stop= 1'b1; 
                        scc_valid = 1'b0;
                    end
                    default: begin
                        amino_out = 5'b01000; // Tryptophan
                        codon_signals.start = 1'b0; 
                        codon_signals.stop = 1'b0; 
                        scc_valid = 1'b1;
                    end
                endcase
            end
            6'b0100??: begin
                case(purine)
                    1'b1: begin
                        amino_out = 5'b11111; // STOP
                        codon_signals.start = 1'b0; 
                        codon_signals.stop = 1'b1; 
                        scc_valid = 1'b0;
                    end
                    1'b0: begin
                        amino_out = 5'b01001; // Tyrosine
                        codon_signals.start = 1'b0; 
                        codon_signals.stop = 1'b0; 
                        scc_valid = 1'b1;                     
                    end 
                endcase
            end
            default: begin
                amino_out = 5'bxxxxx; // NULL, need further matching
                codon_signals.start = 1'b0; 
                codon_signals.stop = 1'b0; 
                scc_valid = 1'b0;
            end
        endcase
    end
    
endmodule