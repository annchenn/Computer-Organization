// 112550184
module Forwarding_Unit(
    regwrite_mem,
    regwrite_wb,
    idex_regs,
    idex_regt,
    exmem_regd,
    memwb_regd,
    forwarda,
    forwardb
);

// TO DO
// I/O ports
input [4:0] idex_regs, idex_regt, exmem_regd, memwb_regd;
input regwrite_mem, regwrite_wb;
output reg [1:0] forwarda, forwardb;

//00, 10(mem), 01(wb)

// Main function
always @(*) begin
    // ForwardA
    if (regwrite_mem & (|exmem_regd) & (exmem_regd == idex_regs))
        forwarda = 2'b10;  // EX/MEM 
    else if (regwrite_wb & (|memwb_regd) & (memwb_regd == idex_regs))
        forwarda = 2'b01;  // MEM/WB
    else
        forwarda = 2'b00; 
        
    // ForwardB
    if (regwrite_mem & (|exmem_regd) & (exmem_regd == idex_regt))
        forwardb = 2'b10;
    else if (regwrite_wb & (|memwb_regd) & (memwb_regd == idex_regt))
        forwardb = 2'b01;
    else
        forwardb = 2'b00;
end

endmodule