`timescale 1ns / 1ps
module Pipeline_Reg (
    input clk,
    input reset,
    input flush,
    input [31:0] if_pc,
    input [31:0] if_instruction,
    output reg [31:0] ex_pc,
    output reg [31:0] ex_instruction
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ex_pc <= 32'd0;
            ex_instruction <= 32'h00000013; // NOP instruction
        end else if (flush) begin
            ex_pc <= 32'd0;
            ex_instruction <= 32'h00000013; // NOP instruction (synchronous flush)
        end else begin
            ex_pc <= if_pc;
            ex_instruction <= if_instruction;
        end
    end
endmodule