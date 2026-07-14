`timescale 1ns / 1ps
module tb_dp();
    logic [5:0] codon_in;
    codon_pkg::codon_signals_t codon_signals;
    logic [4:0] amino_out;
    logic valid;
    
    datapath d1 (
        .codon_in(codon_in),
        .codon_signals(codon_signals),
        .amino_out(amino_out),
        .valid(valid)
    );
    
    task present_codon(input [5:0] codon, input [4:0] expected, input string name);
        codon_in = codon;
        #10;
        $display("---------------------------------------------");
        $display("Codon     : %s (%b)", name, codon);
        $display("amino_out : %b (expected %b) | %s", amino_out, expected, (amino_out === expected) ? "PASS" : "FAIL");
        $display("valid     : %b", valid);
        $display("start     : %b | stop: %b", codon_signals.start, codon_signals.stop);
        $display("purine    : %b", d1.purine);
        $display("first2    : %b", d1.first2);
        $display("third     : %b", d1.third);
        $display("scc_amino : %b | scc_valid: %b", d1.scc_amino, d1.scc_valid);
        $display("red_amino : %b | red_valid: %b", d1.red_amino, d1.red_valid);
        $display("tbr_amino : %b | tbr_valid: %b", d1.tbr_amino, d1.tbr_valid);
        $display("---------------------------------------------");
    endtask
    
    initial begin
        codon_in = 6'b000000;
        #10;
        
        // AUG - Methionine (START, special_codon_checker)
        present_codon(6'b000110, 5'b00110, "AUG (Met/START)");
        
        // AUA - Isoleucine (special_codon_checker)
        present_codon(6'b000100, 5'b00100, "AUA (Ile)      ");
        
        // UGA - STOP (special_codon_checker)
        present_codon(6'b011000, 5'b11111, "UGA (STOP)     ");
        
        // UAA - STOP (special_codon_checker, purine path)
        present_codon(6'b010000, 5'b11111, "UAA (STOP)     ");
        
        // GGU - Glycine (red_rom, fourfold degenerate)
        present_codon(6'b101001, 5'b00000, "GGU (Gly)      ");
        
        // GCC - Alanine (red_rom, fourfold degenerate)
        present_codon(6'b101111, 5'b00001, "GCC (Ala)      ");
        
        // CCC - Proline (red_rom, fourfold degenerate)
        present_codon(6'b111111, 5'b00101, "CCC (Pro)      ");
        
        // UUU - Phenylalanine (third_base_rom, pyrimidine)
        present_codon(6'b010101, 5'b00111, "UUU (Phe)      ");
        
        // UUG - Leucine (third_base_rom, purine)
        present_codon(6'b010110, 5'b00011, "UUG (Leu)      ");
        
        // CAC - Histidine (third_base_rom, pyrimidine)
        present_codon(6'b110011, 5'b10011, "CAC (His)      ");
        
        // CAA - Glutamine (third_base_rom, purine)
        present_codon(6'b110000, 5'b01110, "CAA (Gln)      ");
        
        $display("Datapath testbench complete");
        $finish;
    end

endmodule