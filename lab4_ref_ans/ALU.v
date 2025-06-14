// ID
module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
// I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

// Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

// Parameter
assign zero_o = (result_o == 0);

// Main function
always @(*) begin
	case(ctrl_i)	
		4'b0000: result_o <= src1_i + src2_i;                        // add, lw, sw, addi
		4'b0001: result_o <= src1_i - src2_i;                        // sub, beq, bne
		4'b0010: result_o <= src1_i & src2_i;                        // and
		4'b0011: result_o <= src1_i | src2_i;                        // or
		4'b0100: result_o <= ~(src1_i | src2_i);                     // nor
		4'b0101: result_o <= (src1_i < src2_i) ? 32'b1 : 32'b0;      // slt
		default: result_o <= 32'b0;
	endcase
end

endmodule