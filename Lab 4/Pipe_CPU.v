// 112550184

`include "Adder.v"
`include "ALU_Ctrl.v"
`include "ALU.v"
`include "Reg_File.v"
`include "Data_Memory.v"
`include "Decoder.v"
`include "MUX_2to1.v"
`include "Pipe_Reg.v"
`include "ProgramCounter.v"
`include "Shift_Left_Two_32.v"
`include "Sign_Extend.v"
`include "Instruction_Memory.v"

`timescale 1ns / 1ps

module Pipe_CPU(
    clk_i,
    rst_i
    );

input clk_i;
input rst_i;

// TO DO

    // Internal Signals
    wire    [31:0] pc_in, pc_plus4_IF,pc_plus4_ID,pc_plus4_EX,pc_out, instr_IF, instr_ID, branchAddr_EX, branchAddr_MEM;
    wire    [31:0] ReadData1_ID, ReadData2_ID,ReadData1_EX, ReadData2_EX, ReadData2_MEM, WriteData, MemData_MEM, MemData_WB;
    wire    MemRead_ID, MemRead_EX, MemRead_MEM, MemWrite_ID, MemWrite_EX, MemWrite_MEM, ALUSrc_ID, ALUSrc_EX;
    wire    zero_EX, zero_MEM, overflow, PCSrc, RegWrite_ID, RegWrite_EX, RegWrite_MEM, RegWrite_WB;//branch result = zero & Branch
    wire    [1:0] ALUOp_ID, ALUOp_EX;
    wire    [4:0] writeReg_EX, writeReg_MEM, writeReg_WB; 
    wire    [1:0] shift, Branch_ID, Branch_EX, Branch_MEM;//01: sll, slr/10:sllv, srlv
    wire    [3:0] ALU_Ctrl;
    wire    [31:0] sign_extend_ID, sign_extend_EX, ALU_in, ALU_result_EX, ALU_result_MEM, ALU_result_WB, branch_addr_shift, write_data;
    wire    dummy;
    wire    [4:0]instr0_ID, instr0_EX, instr1_ID, instr1_EX;
    wire    MemtoReg_ID, MemtoReg_EX, MemtoReg_MEM, MemtoReg_WB, RegDst_ID, RegDst_EX;
    wire    [1:0]dummy2;

// IF stage
    // Components
    ProgramCounter PC(
        .clk_i(clk_i),      
        .rst_i(rst_i),     
        .pc_in_i(pc_in),   
        .pc_out_o(pc_out) 
    );

    //pc+4
    Adder pcPlus4(
        .src1_i(pc_out),
        .src2_i(32'd4),
        .sum_o(pc_plus4_IF)
    );

    //fetch instruction
    Instruction_Memory IM(
        .addr_i(pc_out),  
        .instr_o(instr_IF)    
    );

//IF/ID reg
    Pipe_Reg #(.size(32)) PC_plus4_1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(pc_plus4_IF),
        .data_o(pc_plus4_ID)
    );

    Pipe_Reg #(.size(32))instr(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(instr_IF),
        .data_o(instr_ID)
    );
    
// ID stage
    //read register
    Reg_File RF(
        .clk_i(clk_i),
        .rst_i(rst_i) ,     
        .RSaddr_i(instr_ID[25:21]),
        .RTaddr_i(instr_ID[20:16]),
        .RDaddr_i(writeReg_WB), 
        .RDdata_i(write_data),
        .RegWrite_i(RegWrite_WB),
        .RSdata_o(ReadData1_ID),  
        .RTdata_o(ReadData2_ID) 
    );

    Decoder decoder(
        .instr_op_i(instr_ID[31:26]),
        .ALU_op_o(ALUOp_ID),
        .ALUSrc_o(ALUSrc_ID),
        .RegWrite_o(RegWrite_ID),
        .RegDst_o(RegDst_ID),
        .Branch_o(Branch_ID),
        .Jump_o(dummy),
        .MemRead_o(MemRead_ID),
        .MemWrite_o(MemWrite_ID),
        .MemtoReg_o(MemtoReg_ID)
    );

    //address sign extend
    Sign_Extend signExtend(
        .data_i(instr_ID[15:0]),
        .data_o(sign_extend_ID)
    );

    assign instr0_ID = instr_ID[20:16];
    assign instr1_ID = instr_ID[15:11];

//ID/EX reg
    Pipe_Reg #(.size(5))instr0(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(instr0_ID),
        .data_o(instr0_EX)
    );

    Pipe_Reg #(.size(5))instr1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(instr1_ID),
        .data_o(instr1_EX)
    );

    Pipe_Reg #(.size(32))sign_extend(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(sign_extend_ID),
        .data_o(sign_extend_EX)
    );

    Pipe_Reg #(.size(32))ReadData1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(ReadData1_ID),
        .data_o(ReadData1_EX)
    );

    Pipe_Reg #(.size(32))ReadData2_1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(ReadData2_ID),
        .data_o(ReadData2_EX)
    );

    Pipe_Reg #(.size(32))PC_plus4_2(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(pc_plus4_ID),
        .data_o(pc_plus4_EX)
    );
    
    //control signals
    //EX
    Pipe_Reg #(.size(2))ALUOp(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(ALUOp_ID),
        .data_o(ALUOp_EX)
    );

    Pipe_Reg #(.size(1))ALUSrc(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(ALUSrc_ID),
        .data_o(ALUSrc_EX)
    );

    Pipe_Reg #(.size(1))RegDst(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(RegDst_ID),
        .data_o(RegDst_EX)
    );

    //MEM
    Pipe_Reg #(.size(2))Branch1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(Branch_ID),
        .data_o(Branch_EX)
    );

    Pipe_Reg #(.size(1))MemRead1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(MemRead_ID),
        .data_o(MemRead_EX)
    );

    Pipe_Reg #(.size(1))MemWrite1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(MemWrite_ID),
        .data_o(MemWrite_EX)
    );

    //WB
    Pipe_Reg #(.size(1))RegWrite1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(RegWrite_ID),
        .data_o(RegWrite_EX)
    );

    Pipe_Reg #(.size(1))MemtoReg1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(MemtoReg_ID),
        .data_o(MemtoReg_EX)
    );
// EX stage
    //ALU source(sign extend or read2)
    MUX_2to1 #(.size(32)) mux_ALU_src(
        .data0_i(ReadData2_EX),
        .data1_i(sign_extend_EX),
        .select_i(ALUSrc_EX),
        .data_o(ALU_in)
    );

    //write reg
    MUX_2to1 #(.size(5)) mux_write_reg(
        .data0_i(instr0_EX),
        .data1_i(instr1_EX),
        .select_i(RegDst_EX),
        .data_o(writeReg_EX)
    );

    //branch address
    Shift_Left_Two_32 shift_branch_addr(
        .data_i(sign_extend_EX),
        .data_o(branch_addr_shift)
    );
    Adder branch_addr(
        .src1_i(branch_addr_shift),
        .src2_i(pc_plus4_EX),
        .sum_o(branchAddr_EX)
    );

    //ALU control
    ALU_Ctrl alu_control(
        .funct_i(sign_extend_EX[5:0]),
        .ALUOp_i(ALUOp_EX),
        .ALUCtrl_o(ALU_Ctrl),
        .shift_o(dummy2),
        .JumpReg_o(dummy)
    );

    //alu
    ALU alu(
        .src1_i(ReadData1_EX),
        .src2_i(ALU_in),
        .ctrl_i(ALU_Ctrl),
        .shamt_i(sign_extend_EX[10:6]),
        .shift_i(dummy2),
        .result_o(ALU_result_EX),
        .zero_o(zero_EX),
        .overflow(overflow)
    );

//EX/MEM reg
    Pipe_Reg #(.size(32))branchAddr(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(branchAddr_EX),
        .data_o(branchAddr_MEM)
    );

    Pipe_Reg #(.size(1))zero(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(zero_EX),
        .data_o(zero_MEM)
    );

    Pipe_Reg #(.size(32))ALU_result1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(ALU_result_EX),
        .data_o(ALU_result_MEM)
    );

    Pipe_Reg #(.size(32))ReadData2_2(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(ReadData2_EX),
        .data_o(ReadData2_MEM)
    );

    Pipe_Reg #(.size(5))writeReg1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(writeReg_EX),
        .data_o(writeReg_MEM)
    );

    //control signals
    //MEM
    Pipe_Reg #(.size(2))Branch2(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(Branch_EX),
        .data_o(Branch_MEM)
    );

    Pipe_Reg #(.size(1))MemRead2(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(MemRead_EX),
        .data_o(MemRead_MEM)
    );

    Pipe_Reg #(.size(1))MemWrite2(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(MemWrite_EX),
        .data_o(MemWrite_MEM)
    );

    //WB
    Pipe_Reg #(.size(1))RegWrite2(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(RegWrite_EX),
        .data_o(RegWrite_MEM)
    );

    Pipe_Reg #(.size(1))MemtoReg2(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(MemtoReg_EX),
        .data_o(MemtoReg_MEM)
    );

// MEM stage
    assign PCSrc = (Branch_MEM==2'b01 & zero_MEM)|(Branch_MEM==2'b10&~zero_MEM);

    Data_Memory DM(
        .clk_i(clk_i), 
        .addr_i(ALU_result_MEM), 
        .data_i(ReadData2_MEM), 
        .MemRead_i(MemRead_MEM), 
        .MemWrite_i(MemWrite_MEM), 
        .data_o(MemData_MEM)
    );

// MEM/WB reg
    Pipe_Reg #(.size(5))writeReg2(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(writeReg_MEM),
        .data_o(writeReg_WB)
    );

    Pipe_Reg #(.size(32))MemData(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(MemData_MEM),
        .data_o(MemData_WB)
    );

    Pipe_Reg #(.size(32))ALU_result2(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(ALU_result_MEM),
        .data_o(ALU_result_WB)
    );
    
    //control signals
    //WB
    Pipe_Reg #(.size(1))RegWrite3(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(RegWrite_MEM),
        .data_o(RegWrite_WB)
    );

    Pipe_Reg #(.size(1))MemtoReg3(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(MemtoReg_MEM),
        .data_o(MemtoReg_WB)
    );

// WB stage
    MUX_2to1 #(.size(32)) mux_writeData(
        .data0_i(ALU_result_WB),
        .data1_i(MemData_WB),
        .select_i(MemtoReg_WB),
        .data_o(write_data)
    );

    MUX_2to1 #(.size(32)) pcSrc(
        .data0_i(pc_plus4_IF),
        .data1_i(branchAddr_MEM),
        .select_i(PCSrc),
        .data_o(pc_in)
    );



endmodule