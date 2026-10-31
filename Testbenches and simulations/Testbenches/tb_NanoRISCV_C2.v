`timescale 1ns / 1ps

module tb_NanoRISCV_C2;

    reg clk;
    reg reset;
    wire [31:0] debug_out;

    NanoRISCV_C2 uut (
        .clk(clk), 
        .reset(reset),
        .debug_out(debug_out)
    );

    // 100 MHz clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // --- INJECT INSTRUCTIONS HERE ---
        // We load the program into the blank memory module before releasing reset
        uut.IMEM_Inst.RAM[0] = 32'h00500093; // ADDI x1, x0, 5
        uut.IMEM_Inst.RAM[1] = 32'h00A00113; // ADDI x2, x0, 10
        uut.IMEM_Inst.RAM[2] = 32'h002081B3; // ADD x3, x1, x2 (x3 = 15)
        uut.IMEM_Inst.RAM[3] = 32'h00302023; // SW x3, 0(x0) (mem[0] = 15)
        uut.IMEM_Inst.RAM[4] = 32'h00002203; // LW x4, 0(x0) (x4 = 15)
        uut.IMEM_Inst.RAM[5] = 32'h00418463; // BEQ x3, x4, 8 (Since 15==15, jumps to pc+8)
        uut.IMEM_Inst.RAM[6] = 32'h00100293; // ADDI x5, x0, 1 (Skipped due to branch)
        uut.IMEM_Inst.RAM[7] = 32'hFFFFF36F; // JAL x6, -4 (Valid JAL encoding, jumps back)

        // Hold reset for a short duration
        #15;
        reset = 0;

        // Run for 195ns to account for 2-stage pipeline execution
        #195;

        $finish;
    end
      
endmodule