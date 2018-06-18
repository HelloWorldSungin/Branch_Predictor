

module branch_predictor_local (
	branch_found_EXE,
	branch_taken_EXE,
	pc_f,
	pc_e,
	pcbranch_e,
	branchfound_f,
	predict_pc_f,
	mispredict_pc_e
);
//--Parameters----------------------------------------
parameter ADDR_WIDTH = 32;
parameter BHT_DEPTH = 128;//1<<7;
//--Input Ports---------------------------------------
input branch_found_EXE;
input branch_taken_EXE;
input [ADDR_WIDTH-1:0] pc_f;
input [ADDR_WIDTH-1:0] pc_e;
input [ADDR_WIDTH-1:0] pcbranch_e;
//--Ouput Ports---------------------------------------
output reg [ADDR_WIDTH-1:0] predict_pc_f;
output reg [ADDR_WIDTH-1:0] mispredict_pc_e;
output reg branchfound_f;
//--Registers-----------------------------------------
reg [ADDR_WIDTH-1:0] branch_pc [0:BHT_DEPTH-1];
reg [ADDR_WIDTH-1:0] predict_pc [0:BHT_DEPTH-1];
reg [1:0] predict_state [0:BHT_DEPTH-1];

integer i;
initial begin
	branchfound_f <= 0; predict_pc_f <= 0; mispredict_pc_e <= 0;
	for (i = 0; i < BHT_DEPTH; i = i + 1) begin
		{branch_pc[i], predict_pc[i], predict_state[i]} <= 0;
	end
end

always @(branch_found_EXE or pc_f or branch_taken_EXE) begin

	if (pc_f == branch_pc[pc_f[6:0]] && pc_f[6:0] != 0) begin
		predict_pc_f <= predict_pc[pc_f[6:0]];
		branchfound_f <= 1;
	end else begin
		predict_pc_f <= pc_f + 4;
		branchfound_f <= 0;
	end

	if (~branch_found_EXE & branch_taken_EXE) begin
		mispredict_pc_e <= pcbranch_e;
		branch_pc[pc_e[6:0]] <= pc_e;
		predict_pc[pc_e[6:0]] <= pcbranch_e;
		predict_state[pc_e[6:0]] <= 2'b00;
	end
	else if (branch_found_EXE & ~branch_taken_EXE) begin
		mispredict_pc_e <= pc_e + 4;
		if (predict_state[pc_e[6:0]] != 2'b00)
			predict_state[pc_e[6:0]] <= predict_state[pc_e[6:0]] - 1;
	end
	else if (branch_found_EXE & branch_taken_EXE) begin
		if (predict_state[pc_e[6:0]] != 2'b11)
			predict_state[pc_e[6:0]] <= predict_state[pc_e[6:0]] + 1;
	end
end
endmodule

