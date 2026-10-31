`timescale 1ns / 1ps
module RegisterFile (
    input clk,
    input write_enable,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);
    reg [31:0] registers [31:0];
    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'd0;
        end
    end

    assign read_data1 = (read_reg1 == 5'd0) ? 32'd0 : registers[read_reg1];
    assign read_data2 = (read_reg2 == 5'd0) ? 32'd0 : registers[read_reg2];

    always @(posedge clk) begin
        if (write_enable && (write_reg != 5'd0)) begin
            registers[write_reg] <= write_data;
        end
    end
endmodule