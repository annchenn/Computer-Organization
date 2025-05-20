// 112550184
module Shift_Left_Two_32(
    data_i,
    data_o
    );

// I/O ports                    
input [31:0] data_i;

output [32-1:0] data_o;

// Internal Signals
wire    [32-1:0] data_o;

// Main function

assign data_o = data_i<<2;
     
endmodule
