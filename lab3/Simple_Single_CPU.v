// 112550184

`include "ProgramCounter.v"
`include "Instr_Memory.v"
`include "Reg_File.v"
`include "Data_Memory.v"
`include "Adder.v"
`include "Sign_Extend.v"
`include "Mux_2to1.v"
`include "ALU_Ctrl.v"
`include "Decoder.v"
`include "Shift_Left_Two_32.v"
`include "MUX_3to1.v"
`include "ALU.v"

module Simple_Single_CPU(
        clk_i,
	rst_i
);
		
        // I/O port
        input         clk_i;
        input         rst_i;

        // Internal Signals
        wire    [31:0] pc_in, pc_plus4, pc_out, instr, branchAddr, jumpAddr;
        wire    [31:0] ReadData1, ReadData2, WriteData, MemData;
        wire    Jump, MemRead, MemWrite, ALUSrc;
        wire    zero, overflow, branch_result, JumpReg, RegWrite;//branch result = zero & Branch
        wire    [1:0] ALUOp;
        wire    [4:0] writeReg;
        wire    [1:0] shift, MemtoReg, Branch, RegDst;//01: sll, slr/10:sllv, srlv
        wire    [3:0] ALU_Ctrl;
        wire    [31:0] write_data;
        wire    [31:0] sign_extend, ALU_in, ALU_result, jump_addr_shift, branch_addr_shift;
        wire    [31:0] branch_mux, jump_mux;

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
                .sum_o(pc_plus4)
        );

        //fetch instruction
        Instr_Memory IM(
                .pc_addr_i(pc_out),  
                .instr_o(instr)    
        );

        //write reg
        MUX_3to1 #(.size(5)) mux_write_reg(
                .data0_i(instr[20:16]),
                .data1_i(instr[15:11]),
                .data2_i(5'd31),
                .select_i(RegDst),
                .data_o(writeReg)
        );

        //read register
        Reg_File Registers(
                .clk_i(clk_i),
                .rst_i(rst_i) ,     
                .RSaddr_i(instr[25:21]),
                .RTaddr_i(instr[20:16]),
                .RDaddr_i(writeReg), 
                .RDdata_i(write_data),
                .RegWrite_i(RegWrite),
                .RSdata_o(ReadData1),  
                .RTdata_o(ReadData2) 
        );

        Decoder decoder(
                .instr_op_i(instr[31:26]),
                .ALU_op_o(ALUOp),
                .ALUSrc_o(ALUSrc),
                .RegWrite_o(RegWrite),
                .RegDst_o(RegDst),
                .Branch_o(Branch),
                .Jump_o(Jump),
                .MemRead_o(MemRead),
                .MemWrite_o(MemWrite),
                .MemtoReg_o(MemtoReg)
        );

        //address sign extend
        Sign_Extend signExtend(
                .data_i(instr[15:0]),
                .data_o(sign_extend)
        );

        //ALU source(sign extend or read2)
        MUX_2to1 #(.size(32)) mux_ALU_src(
                .data0_i(ReadData2),
                .data1_i(sign_extend),
                .select_i(ALUSrc),
                .data_o(ALU_in)
        );

        //ALU control
        ALU_Ctrl alu_control(
                .funct_i(instr[5:0]),
                .ALUOp_i(ALUOp),
                .ALUCtrl_o(ALU_Ctrl),
                .shift_o(shift),
                .JumpReg_o(JumpReg)
        );

        //alu
        ALU alu(
                .src1_i(ReadData1),
                .src2_i(ALU_in),
                .ctrl_i(ALU_Ctrl),
                .shamt_i(instr[10:6]),
                .shift_i(shift),
                .result_o(ALU_result),
                .zero_o(zero),
                .overflow(overflow)
        );

        // jump address
        Shift_Left_Two_32 shift_jump_addr(
                .data_i({6'b000000, instr[25:0]}),
                .data_o(jump_addr_shift)
        );
        assign jumpAddr = {pc_plus4[31:28], jump_addr_shift[27:0]};

        //branch address
        Shift_Left_Two_32 shift_branch_addr(
                .data_i(sign_extend),
                .data_o(branch_addr_shift)
        );
        Adder branch_addr(
                .src1_i(branch_addr_shift),
                .src2_i(pc_plus4),
                .sum_o(branchAddr)
        );
        assign branch_result = (Branch==2'b01 & zero)|(Branch==2'b10&~zero);
        MUX_2to1 #(.size(32)) mux_branch(
                .data0_i(pc_plus4),
                .data1_i(branchAddr),
                .select_i(branch_result),
                .data_o(branch_mux)
        );

        MUX_2to1 #(.size(32)) mux_jump(
                .data0_i(branch_mux),
                .data1_i(jumpAddr),
                .select_i(Jump),
                .data_o(jump_mux)
        );

        //jr
        MUX_2to1 #(.size(32)) mux_jr(
                .data0_i(jump_mux),
                .data1_i(ReadData1),
                .select_i(JumpReg),
                .data_o(pc_in)
        );
        
        //data memory
        Data_Memory Data_Memory(
                .clk_i(clk_i), 
                .addr_i(ALU_result), 
                .data_i(ReadData2), 
                .MemRead_i(MemRead), 
                .MemWrite_i(MemWrite), 
                .data_o(MemData)
        );

        MUX_3to1 #(.size(32)) mux_WriteData_mux(
                .data0_i(ALU_result),
                .data1_i(MemData),
                .data2_i(pc_plus4),
                .select_i(MemtoReg),
                .data_o(write_data)
        );


endmodule
