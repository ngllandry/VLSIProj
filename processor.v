module processor(
input wire clk,
input wire CLB,
input wire [7:0] Instruction,

output wire [15:0] proc_out
);

/*reg uclk;

always @(posedge clk) begin
	uclk = ~uclk;
end*/

wire [7:0] InstIR;
wire [7:0] regin;
wire [3:0] imm;
wire loadreg;
wire incpc;
wire loadpc;
wire selpc;
wire loadir;
wire [7:0] inst;
wire zout;
wire cout;
wire [3:0] selalu;
wire loadacc;
wire [1:0] selacc;
wire [7:0] regout;
wire [7:0] alures;

wire [7:0] pcout;

assign imm = inst[7:4];
assign InstIR = Instruction;


reg_file u_register_file(
	.reg_in (regin),
	.RegAddr (imm),
	.clk (clk),
	.CLB (CLB),
	.LoadReg (loadreg),
	
	.reg_out (regout)
);

program_counter u_program_counter(
	.regIn (regin),
	.imm (imm),
	.CLB (),
	.clk (clk),
	.IncPC (incpc),
	.LoadPC (loadpc),
	.selPC (selpc),

	.address (pcout)
);

IR u_IR(
	.clk (clk),
	.CLB (),
	.LoadIR (loadir),
	.Instruction (InstIR), // comes from test_bench

	.I (inst)
);

controller_fsm u_controller_fsm(
	.zout (zout),
	.cout (cout),
	.clk (clk),
	.CLB (),
	.I (inst),

	.LoadIR (loadir),
	.IncPC (incpc),
	.selPC (selpc),
	.LoadPC (loadpc),
	.LoadReg (loadreg),
	.LoadAcc (loadacc),
	.SelAcc (selacc),
	.SelALU (selalu)
);

ALU u_ALU(
	.a (regin),
	.b (regout),
	.SelALU (selalu),

	.result (alures),
	.cout (cout),
	.zout (zout)
);

accumulator u_accumulator(
	.LoadAcc (loadacc),
	.SelAcc (selacc),
	.clk (clk),
	.CLB (),
	.imm (imm),
	.reg_out (regout),
	.result (alures),
	
	.regIn (regin)
);

assign proc_out = {pcout[7:0], regin[7:0]};

endmodule



