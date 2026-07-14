`timescale 1ns / 1ps

module datapath(
    input [5:0] codon_in,
    output codon_pkg::codon_signals_t codon_signals,
    output logic [4:0] amino_out,
    output logic valid
    );
    
    logic purine;
    logic [3:0] first2;
    logic [1:0] third;
    
    logic [4:0] scc_amino, red_amino, tbr_amino;
    logic scc_valid, red_valid, tbr_valid;
    
    check_purine p_checker(
        .third(codon_in[1:0]), .purine(purine)
    );
    
    special_codon_checker scc1 (
        .codon_in(codon_in), .purine(purine), .amino_out(scc_amino), 
        .codon_signals(codon_signals), .scc_valid(scc_valid)
    );
    
    decoder d1(
        .codon_in(codon_in), .first2(first2), .third(third)
    );
    
    red_rom r1(
        .first2(first2), .amino_out(red_amino), .red_valid(red_valid)
    );
    
    third_base_rom tr1 (
        .first2(first2), .purine(purine),
        .amino_out(tbr_amino), .tbr_valid(tbr_valid)
    );
    
    assign amino_out = (scc_valid | codon_signals.stop | codon_signals.start) ? scc_amino :
                       (red_valid) ? red_amino : tbr_amino;
    
    assign valid = scc_valid | red_valid | tbr_valid;
    
endmodule
