

module if_id_reg (
	clk, reset,
	enable, clr,
	instr_f,
	pcplus4_f,
	instr_d,
	pcplus4_d,
	
	pc_f,
	pc_d,
	branchfound_f,
	branchfound_d
);
//--Input Ports-------------
input clk, reset, enable, clr;
input [31:0] instr_f;
input [31:0] pcplus4_f;

input [31:0] pc_f;
input branchfound_f;
//--Output Ports------------
output reg [31:0] instr_d;
output reg [31:0] pcplus4_d;

output reg [31:0] pc_d;
output reg branchfound_d;


//--
always @ (posedge clk or posedge reset) begin
	if (reset) begin
		instr_d <= 0;
		pcplus4_d <= 0;
		branchfound_d <= 0;
		pc_d <= 0;
	end
	else begin
		if (enable) begin
			if (clr) begin
				instr_d <= 0;
				pcplus4_d <= 0;
				branchfound_d <= 0;
				pc_d <= 0;
			end
			else begin
				instr_d <= instr_f;
				pcplus4_d <= pcplus4_f;
				branchfound_d <= branchfound_f;
				pc_d <= pc_f;
			end
		end
	end
end

endmodule
