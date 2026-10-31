`timescale 1ns / 1ps
module tb_ImmGen;
    reg [31:0] instruction;
    wire [31:0] imm_out;
    
    ImmGen uut (.instruction(instruction), .imm_out(imm_out));
    
    initial begin
        instruction = 32'h00F00093; #10; // I-type (ADDI x1, x0, 15)
        instruction = 32'h00102023; #10; // S-type (SW x1, 0(x0))
        $finish;
    end
endmodule