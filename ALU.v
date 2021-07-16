`timescale 1ns/1ps

module ALU (a, b, SelALU, result, cout, zout);
input [7:0] a, b;
input [3:0] SelALU;
output[7:0] result;
output cout, zout;

wire cout, zout;
reg [8:0] r;


always @(a or b or SelALU) begin
	if (SelALU == 4'b0001)
		r <= a + b;
	else if (SelALU  == 4'b0010)
		r <= a - b;
	else if (SelALU  == 4'b0011)
		r <= !(a | b);
	else if (SelALU  == 4'b0100)
		r <= a >> 1;
	else if (SelALU  == 4'b0101)
		r <= a << 1;
	else if (SelALU  == 4'b0110)
		r <= a;
	else if (SelALU == 4'b0111)
		r <= b;
	else
		r <= 0;
	
	/*case(ALU_sel) 
		2'b10: r <= a + b; //add
		2'b11: r <= a - b; //sub
		2'b01: r <= !(a | b); //nor
	endcase

	case(load_shift)
		2'b11: r <= a >> 1; //shift right
		2'b01: r <= a << 1; //shift left
		2'b10: r <= a; //load
		default: r <= 0; //reset
		
	endcase*/
end



assign cout = r[8];
assign result = r[3:0];
assign zout = r[7:0] == 0 ? 1 : 0;

endmodule

