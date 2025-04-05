//112550184
`timescale 1ns/1ps
`include "MUX_2to1.v"
`include "MUX_4to1.v"

module ALU_1bit(
	input				src1,       //1 bit source 1  (input)
	input				src2,       //1 bit source 2  (input)
	input				less,       //1 bit less      (input)
	input 				Ainvert,    //1 bit A_invert  (input)
	input				Binvert,    //1 bit B_invert  (input)
	input 				cin,        //1 bit carry in  (input)
	input 	    [2-1:0] operation,  //2 bit operation (input)
	output reg          result,     //1 bit result    (output)
	output reg          cout,        //1 bit carry out (output)
	output reg			set
	);
		
/* Write down your code HERE */
	wire a, b;
	wire and_, or_, add;
	wire tmp_result;

	MUX_2to1 invA(
		.src1(src1),
		.src2(~src1),
		.select(Ainvert),
		.result(a)
	);

	MUX_2to1 invB(
		.src1(src2),
		.src2(~src2),
		.select(Binvert),
		.result(b)
	);

	assign and_ = a & b;
	assign or_ = a | b;
	assign add = a ^ b ^ cin;
	always @(*) begin
		cout = (a&b)|(a&cin)|(b&cin);
	end

	MUX_4to1 ans(
		.src1(and_),
		.src2(or_),
		.src3(add),
		.src4(less),
		.select(operation),
		.result(tmp_result)
	);

	always @(*) begin
		set = add;
		result = tmp_result;
	end
endmodule
