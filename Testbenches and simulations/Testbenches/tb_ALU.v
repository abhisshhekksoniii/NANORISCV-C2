`timescale 1ns / 1ps
module tb_ALU;
    reg [31:0] A, B;
    reg [3:0] ALU_Control;
    wire [31:0] Result;
    wire Zero;
    
    ALU uut (.A(A), .B(B), .ALU_Control(ALU_Control), .Result(Result), .Zero(Zero));
    
    initial begin
        A = 32'd10; B = 32'd5; ALU_Control = 4'b0000; #10; // ADD
        ALU_Control = 4'b0001; #10; // SUB
        A = 32'd5; B = 32'd5; ALU_Control = 4'b0001; #10; // SUB (Check Zero flag = 1)
        $finish;
    end
endmodule