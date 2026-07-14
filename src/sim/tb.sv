`timescale 1ns / 1ps
module tb;

    logic clk, rst, en;
    logic [5:0] codon_in;
    logic [4:0] amino_out;
    
    top uut (
        .clk(clk), .rst(rst), .en(en),
        .codon_in(codon_in), .amino_out(amino_out)
    );
    
    always #5 clk = ~clk;
    
    task wait_cycles(input int n);
        repeat(n) @(posedge clk);
        #1;
    endtask
    
    task present_codon(input [5:0] codon, input [4:0] expected, input string name);
        codon_in = codon;
        wait_cycles(3);
        $display("%s | state: %0d | amino_out: %b | expected: %b | %s",
            name,
            uut.ctrl1.current_state,
            amino_out,
            expected,
            (amino_out === expected) ? "PASS" : "FAIL"
        );
    endtask
    
    initial begin
    
        $monitor("t=%0t | rst=%b | en=%b | codon_in=%b | state=%0d | valid=%b | start=%b | stop=%b | amino_in=%b | amino_out=%b",
            $time, rst, en,
            codon_in,
            uut.ctrl1.current_state,
            uut.d1.valid,
            uut.codon_signals.start,
            uut.codon_signals.stop,
            uut.amino_in,
            amino_out
        );
    
        clk      = 0;
        rst      = 1;
        en       = 0;
        codon_in = 6'b000000;
        
        // reset
        wait_cycles(2);
        rst = 0;
        wait_cycles(1);
        en = 1;
        wait_cycles(1);
        
        // AUG - Methionine / START
        // FSM: IDLE→SEEK_START→TRANSLATE→OUTPUT
        // needs extra cycles to clear IDLE and SEEK_START first
        present_codon(6'b000110, 5'b00110, "AUG (START/Met)");
        wait_cycles(2);
        
        // GGU - Glycine (fourfold degenerate, red_rom)
        // FSM already in TRANSLATE after start
        present_codon(6'b101001, 5'b00000, "GGU (Gly)      ");
        
        // CCC - Proline (fourfold degenerate, red_rom)
        present_codon(6'b111111, 5'b00101, "CCC (Pro)      ");
        
        present_codon(6'b010000, 5'b11111, "UAA (STOP)     ");

        
        // UUU - Phenylalanine (twofold degenerate, third_base_rom)
        present_codon(6'b010101, 5'b00111, "UUU (Phe)      ");
        
        // CAC - Histidine (twofold degenerate, third_base_rom)
        present_codon(6'b110011, 5'b10011, "CAC (His)      ");
        
        // UAA - STOP
        wait_cycles(2);
        
        $display("FSM final state: %0d (expected STOP=4)", uut.ctrl1.current_state);
        $display("Simulation complete");
        $finish;
    end

endmodule