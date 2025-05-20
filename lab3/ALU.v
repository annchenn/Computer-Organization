// 112550184
`include "ALU_1bit.v"
`include "Shifter.v"
module ALU(
	src1_i,
	src2_i,
	ctrl_i,
	shamt_i,
	shift_i,
	
	result_o,
	zero_o,
	overflow
	);
     
	// I/O ports
	input  [32-1:0]  src1_i;
	input  [32-1:0]	 src2_i;
	input  [4-1:0]   ctrl_i;
	input  [5-1:0]	 shamt_i;
	input	[1:0]	shift_i;

	output [32-1:0]	 result_o;
	output           zero_o;
	output           overflow;

	// Internal signals
	wire invA;
	wire invB;
	wire [1:0] op;
	assign invA = ctrl_i[3];
	assign invB = ctrl_i[2];
	assign op = ctrl_i[1:0];

	wire [31:0] carry;
	wire dummy;
	wire [4:0] shift_amount;
	wire leftright;
	wire [31:0] shift_result;
	wire [31:0] alu_result;
	wire set;
	
	// Main function
	assign shift_amount = (shift_i==2'b01) ? shamt_i:src1_i[4:0];
	assign leftright = (ctrl_i==4'b0011)?1'b1:1'b0;

	Shifter shift(
		.result(shift_result),
		.leftRight(leftright),
		.shamt(shift_amount),
		.sftSrc(src2_i)
	);

	ALU_1bit alu0(
		src1_i[0],
		src2_i[0],
		set,
		invA,
		invB,
		invB,
		op,
		alu_result[0],
		carry[0],
		dummy
	);

	genvar i;
	generate
		for(i=1;i<=30;i=i+1) begin
			ALU_1bit alu(
				src1_i[i],
				src2_i[i],
				1'b0,
				invA,
				invB,
				carry[i-1],
				op,
				alu_result[i],
				carry[i],
				dummy
			);
		end
	endgenerate

	ALU_1bit alu31(
		src1_i[31],
		src2_i[31],
		1'b0,
		invA,
		invB,
		carry[30],
		op,
		alu_result[31],
		carry[31],
		set
	);
	
	assign result_o = (ctrl_i==4'b0011||ctrl_i==4'b0100)?shift_result:alu_result;
	assign zero_o = ~(|result_o[31:0]);
	assign overflow = (op == 2'b10 ? carry[30]^carry[31]:0);

endmodule





                    
                    