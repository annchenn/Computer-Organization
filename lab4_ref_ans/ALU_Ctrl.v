// ID
module ALU_Ctrl(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);
          
// I/O ports 
input      [5:0] funct_i;
input      [1:0] ALUOp_i;

output     [3:0] ALUCtrl_o;    
     
// Internal Signals
reg        [3:0] ALUCtrl_o;

always @(*) begin
    case (ALUOp_i)
        2'b00: begin // R-type
            case (funct_i)
                6'b100010: ALUCtrl_o = 4'b0000; // add
                6'b100000: ALUCtrl_o = 4'b0001; // sub
                6'b100101: ALUCtrl_o = 4'b0010; // and
                6'b100100: ALUCtrl_o = 4'b0011; // or
                6'b101010: ALUCtrl_o = 4'b0100; // nor
                6'b100111: ALUCtrl_o = 4'b0101; // slt
                default:   ALUCtrl_o = 4'b1111;
            endcase
        end
        2'b01: ALUCtrl_o = 4'b0000; // lw/sw/addi → add
        2'b10: ALUCtrl_o = 4'b0001; // beq → sub
        2'b11: ALUCtrl_o = 4'b0001; // bne → sub
        default: ALUCtrl_o = 4'b1111;
    endcase
end

endmodule
