`timescale 1ns / 1ps

module check_purine(
    input [1:0] third,
    output logic purine
    );
    
    // A and G are purines, encodings LSB = 0, so if LSB is 0, purine = 1
    assign purine = (third[0] == 0) ? 1 : 0;
    
endmodule