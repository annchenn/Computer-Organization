//112550184
`timescale 1ns/1ps
`include "ALU_1bit.v"
module ALU(
	input                   rst_n,         // negative reset            (input)
	input	     [32-1:0]	src1,          // 32 bits source 1          (input)
	input	     [32-1:0]	src2,          // 32 bits source 2          (input)
	input 	     [ 4-1:0] 	ALU_control,   // 4 bits ALU control input  (input)
	output reg   [32-1:0]	result,        // 32 bits result            (output)
	output reg              zero,          // 1 bit when the output is 0, zero must be set (output)
	output reg              cout,          // 1 bit carry out           (output)
	output reg              overflow       // 1 bit overflow            (output)
	);

/* Write down your code HERE */
	wire ainv = ALU_control[3];
	wire binv = ALU_control[2];
	wire [1:0] op = ALU_control[1:0];
	wire [31:0] tmp_result;
	wire set;
	wire [31:0] carry;
	wire dummy;

	ALU_1bit alu0(
		src1[0],
		src2[0],
		set,
		ainv,
		binv,
		binv,
		op,
		tmp_result[0],
		carry[0],
		dummy
	);

	genvar i;
	generate
		for(i=1;i<=30;i=i+1) begin
			ALU_1bit alu(
				src1[i],
				src2[i],
				1'b0,
				ainv,
				binv,
				carry[i-1],
				op,
				tmp_result[i],
				carry[i],
				dummy
			);
		end
	endgenerate

	ALU_1bit alu31(
		src1[31],
		src2[31],
		1'b0,
		ainv,
		binv,
		carry[30],
		op,
		tmp_result[31],
		carry[31],
		set
	);
	
	always @(*) begin
		result = tmp_result;
		zero = ~(|tmp_result[31:0]);
		cout = (op==2'b10 ? carry[31]: 1'b0);
		overflow = (op == 2'b10 ? carry[30]^carry[31]:0);
	end

endmodule

