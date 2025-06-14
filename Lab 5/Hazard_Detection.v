// 112550184
module Hazard_Detection(
    memread,
    instr_i,
    idex_regt,
    branch,
    pcwrite,
    ifid_write,
    ifid_flush,
    idex_flush,
    exmem_flush
);

// TO DO
//I/O port
input memread;
input [31:0] instr_i;
input [4:0] idex_regt;
input branch;
output reg pcwrite;
output reg ifid_write;
output reg ifid_flush;
output reg idex_flush;
output reg exmem_flush;

//if/id rs rt
wire [4:0] rs = instr_i[25:21];
wire [4:0] rt = instr_i[20:16];

wire load_use_hazard;
assign load_use_hazard = memread & (idex_regt != 5'b00000)&((idex_regt==rs)|(idex_regt==rt));

always @(*) begin
    // default
    pcwrite = 1'b1;
    ifid_write = 1'b1;
    ifid_flush = 1'b0;
    idex_flush = 1'b0;
    exmem_flush = 1'b0;
    
    // Load-Use
    if (load_use_hazard) begin
        pcwrite = 1'b0; 
        ifid_write = 1'b0;
        idex_flush = 1'b1;
    end
    
    // branch
    if (branch) begin
        ifid_flush = 1'b1;
        idex_flush = 1'b1;
        exmem_flush = 1'b1;
    end
end

endmodule