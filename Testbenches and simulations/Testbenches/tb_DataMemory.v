`timescale 1ns / 1ps
module tb_DataMemory;
    reg clk, memread, memwrite;
    reg [31:0] address, write_data;
    wire [31:0] read_data;
    
    DataMemory uut (.clk(clk), .memread(memread), .memwrite(memwrite), .address(address), .write_data(write_data), .read_data(read_data));
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; memread = 0; memwrite = 1; address = 32'd4; write_data = 32'hDEADBEEF; #10;
        memwrite = 0; memread = 1; address = 32'd4; #10;
        $finish;
    end
endmodule