`timescale 1ns/100ps

module test_bench
#(parameter MEMWIDTH = 32)
();

reg [MEMWIDTH-1:0] memory[15:0];
reg clk;
reg CLB;
reg [3:0] address;
wire [15:0] r;
wire [7:0] Instruction;
wire [7:0] PC;
wire [7:0] ACC;
wire [15:0] expected;



assign Instruction = memory[address][23:16];
assign expected = memory[address][15:0];

initial
begin
	$readmemh("test_bench.txt", memory);
	clk = 0;
	CLB = 0;
	address = 0;
	//#500 $stop;
end

always begin
#5 clk = ~clk;
end

always @(posedge clk) begin
	address <= address + 1;
	if(expected !== {PC, ACC} || expected === 16'bx)
		$error("Instruction=%h, expected=%h, received=%h\n", Instruction, expected, {r});
	else
		$display($time, " correct results Instruction=%h result=%h\n", Instruction, {r});
	
end 

processor u_processor(
	.clk (clk),
	.CLB (CLB),
	.Instruction (Instruction),

	.proc_out (r)
);
/*IR u_IR(
	.clk (clk),
	.CLB (CLB),
	.LoadIR (),
	.Instruction (Instruction), // comes from test_bench

	.I ()
);*/


endmodule
