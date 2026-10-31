`timescale 1ns / 1ps
module tb_ProgramCounter;
    reg clk, reset;
    reg [31:0] next_PC;
    wire [31:0] current_PC;
    
    ProgramCounter uut (.clk(clk), .reset(reset), .next_PC(next_PC), .current_PC(current_PC));
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; reset = 1; next_PC = 32'h00000004;
        #10 reset = 0;
        #10 next_PC = 32'h00000008;
        #10 $finish;
    end
endmodule