// 112550184
module ALU_Ctrl(
        funct_i,
        ALUOp_i,
        ALUCtrl_o,
        shift_o,
        JumpReg_o
        );
          
// I/O ports 
input      [6-1:0] funct_i;
input      [2-1:0] ALUOp_i;

output  [4-1:0] ALUCtrl_o;  
output  [2-1:0] shift_o;
output  JumpReg_o;
     
// Internal Signals
reg [4-1:0] ALUCtrl_o;
reg [2-1:0] shift_o;
reg     JumpReg_o;
// Main function
always @(*) begin
    JumpReg_o=1'b0;
    shift_o=2'b00;
    ALUCtrl_o = 4'b0000;
    if (ALUOp_i == 2'b00) begin //lw, sw
        ALUCtrl_o = 4'b0010;
    end
    else if (ALUOp_i == 2'b01) begin //branch
        ALUCtrl_o = 4'b0110;
    end
    else if (ALUOp_i == 2'b10) begin//r type
        case(funct_i)
            6'b100010: ALUCtrl_o = 4'b0010;//Add
            6'b100000: ALUCtrl_o = 4'b0110;//sub
            6'b100101: ALUCtrl_o = 4'b0000;//and
            6'b100100: ALUCtrl_o = 4'b0001;//or
            6'b101010: ALUCtrl_o = 4'b1100;//nor
            6'b100111: ALUCtrl_o = 4'b0111;//slt
            6'b000000: begin //sll
                ALUCtrl_o = 4'b0011;
                shift_o = 2'b01; // Use shift amount from instruction
            end
            6'b000010: begin //srl
                ALUCtrl_o = 4'b0100;
                shift_o = 2'b01; // Use shift amount from instruction
            end
            6'b000100: begin //sllv
                ALUCtrl_o = 4'b0011;
                shift_o = 2'b10; // Use shift amount from register
            end
            6'b000110: begin //srlv
                ALUCtrl_o = 4'b0100;
                shift_o = 2'b10; // Use shift amount from register
            end
            6'b001000: begin
                ALUCtrl_o = 4'b0000; //jr - typically just passes the value
                JumpReg_o=1'b1;
            end
        endcase
    end
end  

endmodule