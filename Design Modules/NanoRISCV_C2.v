`timescale 1ns / 1ps

module NanoRISCV_C2 (
    input clk,   
    input reset,
    output [31:0] debug_out
);

    // Stage 1 (IF) Wires
    wire [31:0] pc_next, pc_current, instruction, pc_plus_4;     
    
    // Stage 2 (EX) Wires
    wire [31:0] ex_pc, ex_instruction;
    wire reg_write, alu_src, memwrite, memread, mem_to_reg, branch, zero_flag, take_branch;
    wire [3:0] alu_op;
    wire [31:0] read_data1, read_data2, write_back_data, imm_ext, alu_in2, alu_result, mem_read_data, branch_target;

    // --- STAGE 1: INSTRUCTION FETCH (IF) ---
    ProgramCounter PC_Inst (.clk(clk), .reset(reset), .next_PC(pc_next), .current_PC(pc_current));
    PC_Adder Adder_Inst (.pc_in(pc_current), .pc_out(pc_plus_4));
    InstructionMemory IMEM_Inst (.read_address(pc_current), .instruction(instruction));

    // --- PIPELINE REGISTER ---
    Pipeline_Reg IF_EX_Reg (
        .clk(clk),
        .reset(reset),
        .flush(take_branch),
        .if_pc(pc_current),
        .if_instruction(instruction),
        .ex_pc(ex_pc),
        .ex_instruction(ex_instruction)
    );

    // --- STAGE 2: EXECUTE, MEMORY & WRITEBACK (EX) ---
    ControlUnit CU_Inst (
        .opcode(ex_instruction[6:0]),
        .Branch(branch),      
        .RegWrite(reg_write),
        .ALUSrc(alu_src),
        .MemWrite(memwrite),
        .MemRead(memread),
        .MemtoReg(mem_to_reg),
        .ALUOp(alu_op)
    );

    RegisterFile RegFile_Inst (
        .clk(clk),
        .write_enable(reg_write),      
        .read_reg1(ex_instruction[19:15]),
        .read_reg2(ex_instruction[24:20]),
        .write_reg(ex_instruction[11:7]), 
        .write_data(write_back_data),  
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    ImmGen ImmGen_Inst (.instruction(ex_instruction), .imm_out(imm_ext));
    Mux2to1 ALUSrc_Mux (.in0(read_data2), .in1(imm_ext), .sel(alu_src), .out(alu_in2));
    
    ALU ALU_Inst (
        .A(read_data1),        
        .B(alu_in2),          
        .ALU_Control(alu_op), 
        .Result(alu_result),
        .Zero(zero_flag)
    );

    DataMemory DataMem_Inst (
        .clk(clk),
        .memwrite(memwrite),
        .memread(memread),
        .address(alu_result),     
        .write_data(read_data2),  
        .read_data(mem_read_data)
    );

    Mux2to1 MemToReg_Mux (.in0(alu_result), .in1(mem_read_data), .sel(mem_to_reg), .out(write_back_data));

    // Branching Logic
    assign branch_target = ex_pc + imm_ext; 
    assign take_branch = branch & zero_flag;
    assign pc_next = take_branch ? branch_target : pc_plus_4;

    // --- ASSIGN DEBUG OUTPUT ---
    assign debug_out = alu_result;

endmodule