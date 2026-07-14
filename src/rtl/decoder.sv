`timescale 1ns / 1ps

module decoder(
    input [5:0] codon_in,
    output logic [3:0] first2,
    output logic [1:0] third
    );
    
    always_comb begin
        first2 = codon_in[5:2];
        third = codon_in[1:0];
    end
    
endmodule
