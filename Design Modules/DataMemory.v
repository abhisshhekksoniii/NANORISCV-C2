`timescale 1ns / 1ps
module DataMemory (
    input clk,
    input memread,
    input memwrite,
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] read_data
);
    reg [31:0] memory [0:255];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] = 32'd0;
        end
    end

    always @(posedge clk) begin
        if (memwrite) begin
            memory[address >> 2] <= write_data;
        end
    end

    always @(*) begin
        if (memread)
            read_data = memory[address >> 2];
        else
            read_data = 32'd0;
    end
endmodule