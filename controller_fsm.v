module controller_fsm(
output wire LoadIR,
output wire IncPC,
output wire selPC,
output wire LoadPC,
output wire LoadReg,
output wire LoadAcc,
output wire [1:0] SelAcc,
output wire [3:0] SelALU,

input wire zout,
input wire cout,
input wire clk,
input wire CLB,
input wire [7:0] I
);

reg [3:0] Opcode;
reg [1:0] sel_acc;
reg [3:0] sel_alu;
reg load_ir;
reg sel_pc = 0;
reg loadreg;
reg loadpc = 1;
reg loadacc;
reg req_1;
reg out;
reg [1:0] state;
wire [1:0] next_state;
reg incpc;


parameter FETCH = 2'b01;
parameter EXE = 2'b10;

assign next_state = fsm_state(state, req_1);

function [1:0] fsm_state;
	input [1:0] state;
	input req_1;
	case(state)
		FETCH: if (req_1 == 1'b0) begin
			fsm_state = FETCH;
			end else begin
			fsm_state = EXE;
			end
		EXE: if (req_1 == 1'b1) begin
			fsm_state = EXE;
			end else begin
			fsm_state = FETCH;
			end
		default: fsm_state = FETCH;
	endcase
endfunction

always @(posedge clk)
	begin: FSM_SEQ
		if (CLB == 1'b1) begin
			//state <= FETCH;
		end else begin
			state <= next_state;
		end
	end

always @(posedge clk)
	begin: OUTPUT_LOGIC
		if (CLB == 1'b1) begin
			//out <= 1'b0;
		end
		else begin
			case(state)
				FETCH: begin
					out <= 1'b0;
				       end
				EXE: begin
					out <= 1'b1;
				     end
			endcase
		end
	end


always @(posedge clk or CLB) begin
    if (out == 1'b0) begin
	Opcode <= I[3:0];
	req_1 <= 1'b1;
	load_ir <= 0;
	incpc <= 0;
	//loadpc <= 0;
    end
    if (out == 1'b1) begin
	incpc <= 1;
	load_ir <= 1;
	if (Opcode == 4'b0001) begin
		loadacc <= 1;
		sel_pc <= 0;
		loadreg <= 0;
		loadpc <= 0;
		sel_alu <= 4'b0001;
		sel_acc <= 2'b01;
	end
	if (Opcode == 4'b0010) begin
		loadacc <= 1;
		sel_pc <= 0;
		loadreg <= 0;
		loadpc <= 0;
		sel_alu <= 4'b0010;
		sel_acc <= 2'b01;
	end
	if (Opcode == 4'b0011) begin
		loadacc <= 1;
		sel_pc <= 0;
		loadreg <= 0;
		loadpc <= 0;
		sel_alu <= 4'b0011;
		sel_acc <= 2'b01;
	end
	if (Opcode == 4'b0100) begin
		loadacc <= 1;
		sel_pc <= 0;
		loadreg <= 0;
		loadpc <= 0;
		sel_acc <= 2'b10;
		sel_alu <= 4'b0000;
	end
	if (Opcode == 4'b0101) begin
		sel_alu <= 4'b0000;
		sel_pc <= 0;
		loadpc <= 0;
		loadreg <= 1;
		loadacc <= 0;
		sel_acc <= 2'b00;
	end
	if (Opcode == 4'b0110) begin
		if (zout == 1) begin
			loadpc <= 1;
			loadacc <= 0;
			loadreg <= 0;
			sel_pc <= 0;
			sel_alu <= 2'b00;
			sel_alu <= 4'b0000;
		end
	end
		
	if (Opcode == 4'b0111) begin
		if (zout == 1) begin
			loadpc <= 1;
			loadacc <= 0;
			loadreg <= 0;
			sel_pc <= 1;
			sel_alu <= 2'b00;
			sel_alu <= 4'b0000;
		end
	end
		
	if (Opcode == 4'b1000) begin
		if (cout == 1) begin
			loadpc <= 1;
			loadacc <= 0;
			loadreg <= 0;
			sel_pc <= 0;
			sel_alu <= 2'b00;
			sel_alu <= 4'b0000;
		end
	end
		
	if (Opcode == 4'b1010) begin
		if (cout == 1) begin
			loadpc <= 1;
			loadacc <= 0;
			loadreg <= 0;
			sel_pc <= 1;
			sel_alu <= 2'b00;
			sel_alu <= 4'b0000;
		end
	end
		
	if (Opcode == 4'b1011) begin
		loadacc <= 1;
		loadreg <= 0;
		loadpc <= 0;
		sel_pc <= 0;
		sel_alu <= 4'b0101;
		sel_acc <= 2'b01;
	end
	if (Opcode == 4'b1100) begin
		loadacc <= 1;
		loadreg <= 0;
		loadpc <= 0;
		sel_pc <= 0;
		sel_alu <= 4'b0100;
		sel_acc <= 2'b01;
	end
	if (Opcode == 4'b1101) begin
		loadacc <= 1;
		loadreg <= 0;
		loadpc <= 0;
		sel_pc <= 0;
		sel_acc <= 2'b00;
		sel_alu <= 4'b0000;
	end
	if (Opcode == 4'b0000) begin
	end
	if (Opcode == 4'b1111) begin
		$stop;
	end
	req_1 <= 1'b0;
    end

end

assign LoadIR = load_ir;
assign IncPC = incpc;
assign selPC = sel_pc;
assign LoadPC = loadpc;
assign LoadReg = loadreg;
assign LoadAcc = loadacc;
assign SelAcc = sel_acc;
assign SelALU = sel_alu;

endmodule
