`timescale 1ns / 1ps
module tb_ControlUnit;
    reg [6:0] opcode;
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire [3:0] ALUOp;
    
    ControlUnit uut (
        .opcode(opcode), .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg), 
        .ALUOp(ALUOp), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite)
    );
    
    initial begin
        opcode = 7'b0110011; #10; // R-type
        opcode = 7'b0000011; #10; // Load
        opcode = 7'b0100011; #10; // Store
        opcode = 7'b1100011; #10; // Branch
        opcode = 7'b0010011; #10; // I-Type
        $finish;
    end
endmodule