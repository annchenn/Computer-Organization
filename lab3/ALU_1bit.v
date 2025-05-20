//112550184
module ALU_1bit(
	input				src1,       //1 bit source 1  (input)
	input				src2,       //1 bit source 2  (input)
	input				less,       //1 bit less      (input)
	input 				Ainvert,    //1 bit A_invert  (input)
	input				Binvert,    //1 bit B_invert  (input)
	input 				cin,        //1 bit carry in  (input)
	input 	    [2-1:0] operation,  //2 bit operation (input)
	output reg          result,     //1 bit result    (output)
	output reg          cout,        //1 bit carry out (output)
	output reg			set
	);
		
/* Write down your code HERE */
	wire a, b;
	wire and_, or_, add;

    assign a = (Ainvert == 1'b0) ? src1:~src1;
    assign b = (Binvert == 1'b0) ? src2: ~src2;

	assign and_ = a & b;
	assign or_ = a | b;
	assign add = a ^ b ^ cin;
	always @(*) begin
		cout = (a&b)|(a&cin)|(b&cin);
	end

	always @(*) begin
		set = add;
		case(operation)
            2'b00: result = and_;
            2'b01: result = or_;
            2'b10: result = add;
            2'b11: result = less;
        endcase
	end
endmodule
