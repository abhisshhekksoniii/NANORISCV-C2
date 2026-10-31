`timescale 1ns / 1ps
module ControlUnit (
    input [6:0] opcode,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [3:0] ALUOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite
);
    always @(*) begin
        // Default signal assignments to prevent latches
        Branch   = 0;
        MemRead  = 0;
        MemtoReg = 0;
        ALUOp    = 4'b0000;
        MemWrite = 0;
        ALUSrc   = 0;
        RegWrite = 0;

        case(opcode)
            7'b0110011: begin // R-Type
                RegWrite = 1;
                ALUOp    = 4'b0010;
            end
            7'b0000011: begin // LOAD
                ALUSrc   = 1;
                MemtoReg = 1;
                RegWrite = 1;
                MemRead  = 1;
            end
            7'b0100011: begin // STORE
                ALUSrc   = 1;
                MemWrite = 1;
            end
            7'b1100011: begin // BRANCH
                Branch = 1;
                ALUOp  = 4'b0001;
            end
            7'b0010011: begin // I-Type (ADDI)
                RegWrite = 1;
                ALUSrc   = 1;
            end
            default: ; // Retain defaults
        endcase
    end
endmodule