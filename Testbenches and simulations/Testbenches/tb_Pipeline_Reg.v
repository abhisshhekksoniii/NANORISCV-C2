`timescale 1ns / 1ps

module tb_Pipeline_Reg;
    reg clk;
    reg reset;
    reg flush;
    reg [31:0] if_pc;
    reg [31:0] if_instruction;
    
    wire [31:0] ex_pc;
    wire [31:0] ex_instruction;

    // Instantiate the module under test
    Pipeline_Reg uut (
        .clk(clk),
        .reset(reset),
        .flush(flush),
        .if_pc(if_pc),
        .if_instruction(if_instruction),
        .ex_pc(ex_pc),
        .ex_instruction(ex_instruction)
    );

    // 10ns clock period
    always #5 clk = ~clk;

    initial begin
        // 1. Initialize and apply reset
        clk = 0;
        reset = 1;
        flush = 0;
        if_pc = 32'd0;
        if_instruction = 32'd0;
        #15; 
        
        // 2. Release reset, feed normal values
        reset = 0;
        if_pc = 32'd4;
        if_instruction = 32'h00500093; // ADDI
        #10;
        // Verification: ex_pc should be 4, ex_instruction should be 00500093
        
        // 3. Feed next instruction
        if_pc = 32'd8;
        if_instruction = 32'h00A00113; // ADDI
        #10;
        
        // 4. Test synchronous flush (e.g., branch taken)
        flush = 1;
        if_pc = 32'd12;
        if_instruction = 32'h002081B3; // ADD (this should get flushed)
        #10;
        // Verification: ex_pc should be 0, ex_instruction should be 00000013 (NOP)
        
        // 5. Deassert flush, resume normal operation
        flush = 0;
        if_pc = 32'd16;
        if_instruction = 32'h00302023; // SW
        #10;
        
        $finish;
    end
endmodule