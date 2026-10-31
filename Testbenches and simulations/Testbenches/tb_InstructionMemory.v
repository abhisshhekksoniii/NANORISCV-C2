`timescale 1ns / 1ps

module tb_InstructionMemory;
    reg [31:0] read_address;
    wire [31:0] instruction;

    // Instantiate the module under test
    InstructionMemory uut (
        .read_address(read_address),
        .instruction(instruction)
    );

    initial begin
        // Read RAM[0]: ADDI x1, x0, 5
        read_address = 32'd0; #10;
        
        // Read RAM[1]: ADDI x2, x0, 10
        read_address = 32'd4; #10;
        
        // Read RAM[2]: ADD x3, x1, x2
        read_address = 32'd8; #10;
        
        // Read RAM[5]: BEQ x3, x4, 8
        read_address = 32'd20; #10;
        
        // Read RAM[7]: JAL x6, back
        read_address = 32'd28; #10;
        
        // Read RAM[8]: Uninitialized space (should return NOP: 0x00000013)
        read_address = 32'd32; #10;

        $finish;
    end
endmodule