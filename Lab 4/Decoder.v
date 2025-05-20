// 112550184
module Decoder( 
	instr_op_i,
	ALU_op_o,
	ALUSrc_o,
	RegWrite_o,
	RegDst_o,
	Branch_o,
	Jump_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o
);

// I/O ports
input	[6-1:0] instr_op_i;

output reg [2-1:0] ALU_op_o;
output reg [2-1:0] Branch_o;
output reg ALUSrc_o, RegWrite_o, Jump_o, MemRead_o, MemWrite_o, MemtoReg_o,RegDst_o;

// Internal Signals


// Main function
always@(*)begin
	ALU_op_o = 2'b00;
	ALUSrc_o = 1'b0;
	RegWrite_o = 1'b0;
	RegDst_o = 1'b0;
	Branch_o = 2'b00;
	Jump_o = 1'b0;
	MemRead_o = 1'b0;
	MemWrite_o = 1'b0;
	MemtoReg_o = 1'b0;
	case(instr_op_i)
		6'b000000: begin//R-type
			ALU_op_o = 2'b10;
			RegWrite_o = 1'b1;
            RegDst_o = 1'b1; 
            MemtoReg_o = 1'b0;
		end
		6'b001000: begin//addi
			ALU_op_o = 2'b00;  
            ALUSrc_o = 1'b1;   
            RegWrite_o = 1'b1; 
            RegDst_o =1'b0;  
            MemtoReg_o = 1'b0; 
		end
		6'b101011: begin//lw
			ALU_op_o = 2'b00; 
            ALUSrc_o = 1'b1; 
            RegWrite_o = 1'b1; 
            RegDst_o = 1'b0; 
            MemRead_o = 1'b1;  
            MemtoReg_o = 1'b1; 
		end
		6'b100011: begin//sw
 			ALU_op_o = 2'b00; 
            ALUSrc_o = 1'b1;  
            RegWrite_o = 1'b0;
            MemWrite_o = 1'b1; 
		end
		6'b000101: begin//beq
			ALU_op_o = 2'b01;
            ALUSrc_o = 1'b0; 
            RegWrite_o = 1'b0; 
            Branch_o = 2'b01; //01 -> beq
		end
		6'b000100: begin//bne
			ALU_op_o = 2'b01;  
            ALUSrc_o = 1'b0;   
            RegWrite_o = 1'b0; 
            Branch_o = 2'b10; //10 -> bne
		end
		6'b000011: begin//j
			Jump_o = 1'b1;
            RegWrite_o = 1'b0; 
		end
		
		default: begin
			//nop
		end
	endcase

end

endmodule
                

