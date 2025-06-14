// 112550184
module Decoder( 
	instr_op_i, 
	ALUOp_o, 
	ALUSrc_o,
	RegWrite_o,	
	RegDst_o,
	Branch_o,
	MemRead_o, 
	MemWrite_o, 
	MemtoReg_o
);
     
// I/O ports
input	[6-1:0] instr_op_i;

output	[2-1:0] ALUOp_o;
output		    RegDst_o, MemtoReg_o;
output		    ALUSrc_o, RegWrite_o, Branch_o, MemRead_o, MemWrite_o;

// Internal Signals
reg	[2-1:0] ALUOp_o;
reg		    RegDst_o, MemtoReg_o;
reg		    ALUSrc_o, RegWrite_o, Branch_o, MemRead_o, MemWrite_o;

// Main function
always@(*)begin
	case(instr_op_i)
		// R-type
		6'b000000: begin // add sub and or nor slt
			ALUOp_o <= 2'b00;
			ALUSrc_o <= 0;
			RegDst_o <= 1;
			RegWrite_o <= 1;
			Branch_o <= 0;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
		end

		6'b001000: begin // addi
			ALUOp_o <= 2'b01;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			RegWrite_o <= 1;
			Branch_o <= 0;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
		end		
		6'b101011: begin // lw
			ALUOp_o <= 2'b01;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			RegWrite_o <= 1;
			Branch_o <= 0;
			MemRead_o <= 1;
			MemWrite_o <= 0;
			MemtoReg_o <= 1;
		end
		6'b100011: begin // sw
			ALUOp_o <= 2'b01;
			ALUSrc_o <= 1;
			RegDst_o <= 0; // DC
			RegWrite_o <= 0;
			Branch_o <= 0;			
			MemRead_o <= 0;
			MemWrite_o <= 1;
			MemtoReg_o <= 0; // DC
		end
		6'b000101: begin // beq
			ALUOp_o <= 2'b10;
			ALUSrc_o <= 0;
			RegDst_o <= 0; // DC
			RegWrite_o <= 0;	   
			Branch_o <= 1;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0; // DC
		end
		6'b000100: begin // bne
			ALUOp_o <= 2'b11;
			ALUSrc_o <= 0;
			RegDst_o <= 0; // DC 
			RegWrite_o <= 0;	   
			Branch_o <= 1;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0; // DC
		end


		default: begin
			ALUOp_o     <= 2'b00;
			ALUSrc_o    <= 1'b0;
			RegDst_o    <= 1'b0;
			RegWrite_o  <= 1'b0;	
			Branch_o    <= 1'b0;
			MemRead_o   <= 1'b0;
			MemWrite_o  <= 1'b0;
			MemtoReg_o  <= 1'b0;
		end

	endcase
end

endmodule