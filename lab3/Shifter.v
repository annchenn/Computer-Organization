//112550184
module Shifter( result, leftRight, shamt, sftSrc );

    //I/O ports 
    output	[31:0] result;
    
    input		   leftRight;
    input	[4:0]  shamt;
    input	[31:0] sftSrc ;
    
    //Internal Signals
    wire	[31:0] result;
      
    //Main function
    /*your code here*/
    assign result = (leftRight == 1'b1) ? (sftSrc << shamt) : (sftSrc >> shamt);

endmodule