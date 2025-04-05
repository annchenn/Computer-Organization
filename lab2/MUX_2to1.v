//112550184
`timescale 1ns/1ps

module MUX_2to1(
	input      src1,
	input      src2,
	input	   select,
	output reg result
	);

/* Write down your code HERE */
	always @(*) begin
		case(select)
			1'b0: result = src1;
			1'b1: result = src2;
		endcase
	end
endmodule

