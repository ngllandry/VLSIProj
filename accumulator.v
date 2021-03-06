module accumulator(
output wire [7:0] regIn,

input wire LoadAcc,
input wire [1:0] SelAcc,
input wire clk,
input wire CLB,
input wire [3:0] imm,
input wire [7:0] reg_out,
input wire [7:0] result
);

reg [7:0] mux_top;
reg [7:0] mux_bot;

always @(posedge clk or CLB)
begin
	if(CLB == 1'b0) begin
		mux_bot <= 8'b0;
	end
	else begin
		if (LoadAcc == 1'b1) begin
			mux_bot <= SelAcc[0]?reg_out:{4'b0, imm};
		end
		else begin
			mux_bot <= reg_out;
		end
	end

	if(CLB == 1'b0) begin
		mux_top <= 8'b0;
	end
	else begin
		if (LoadAcc == 1'b1) begin
			mux_top <= SelAcc[1]?reg_out:{result};
		end
		else begin
			mux_top <= mux_bot;
		end
	end
end

assign regIn = mux_top[7:0];

endmodule
