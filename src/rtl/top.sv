`timescale 1ns / 1ps
module top(
    input clk, rst, en,
    input [5:0] codon_in,
    output logic [4:0] amino_out
    );
    codon_pkg::codon_signals_t codon_signals;
    logic [4:0] amino_in, amino_reg;
    logic valid;
    
    control ctrl1 (
        .clk(clk), .en(en), .rst(rst),
        .amino_in(amino_in), .codon_signals(codon_signals),
        .amino_reg(amino_out), .valid(valid)
    );
    
    datapath d1 (
        .codon_in(codon_in), .valid(valid),
        .codon_signals(codon_signals), .amino_out(amino_in)
    );
    
    //assign amino_out = amino_reg; // registered output from control drives the pin
    
endmodule