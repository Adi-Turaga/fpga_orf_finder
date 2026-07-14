`timescale 1ns / 1ps

module control(
    input clk, en, rst,
    input [4:0] amino_in, // amino_out from datapath, get passed here
    input codon_pkg::codon_signals_t codon_signals,
    input valid,
    output logic [4:0] amino_reg // output register for external devices
    );
    
    import codon_pkg::*;
    
    states_e current_state, next_state;
    
    always_ff @(posedge clk) begin
        if(rst) begin
            current_state <= IDLE;
            amino_reg <= 5'b11000;
        end else if (en) begin
            current_state <= next_state;
            if(current_state == OUTPUT) begin
                if(codon_signals.stop) amino_reg <= 5'b11111;
                else if(valid) amino_reg <= amino_in;
                else amino_reg <= amino_reg;
            end
        end
    end
    
    always_comb begin
        next_state = current_state;
        case(current_state)
            IDLE: begin
                if(en) next_state = SEEK_START;
            end 
            SEEK_START: begin
                if(codon_signals.start) next_state = OUTPUT;
            end
            OUTPUT: begin
                if(codon_signals.stop) next_state = STOP;
            end
            STOP: begin
                if(!en) next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
        
endmodule
