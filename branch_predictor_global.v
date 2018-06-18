/*
* 2-Level Correlating Global Branch Predictor:
*   - GHR[1:0] Global History Register
*   - BTB: Branch Target Buffer
*
*   # GHR and the corresponding 2 bits of GHT should be updated by the end
*   #   of the EXE stage for the 3 cases:
*   #     1. (pc_f is NOT found in GHT) & (branch is taken)
*   #     2. (pc_f is found in GHT) & (branch is NOT taken)
*   #     3. (pc_f is found in GHT) & (branch is taken)
*/

module branch_predictor_global (
	branch_found_EXE,
	branch_taken_EXE,
	pc_f,
	pc_e,
	pcbranch_e,
	branchfound_f,
	predict_pc_f,
	mispredict_pc_e
);
//--Parameters----------------------------------------------------------------
parameter ADDR_WIDTH = 32;
parameter BTB_ADDR_WIDTH = 7;
localparam BHT_DEPTH = 1 << BTB_ADDR_WIDTH;
//--Input Ports---------------------------------------------------------------
input branch_found_EXE;
input branch_taken_EXE;
input [ADDR_WIDTH-1:0] pc_f;
input [ADDR_WIDTH-1:0] pc_e;
input [ADDR_WIDTH-1:0] pcbranch_e;
//--Ouput Ports---------------------------------------------------------------
output reg [ADDR_WIDTH-1:0] predict_pc_f;
output reg [ADDR_WIDTH-1:0] mispredict_pc_e;
output reg branchfound_f;
//--Wires---------------------------------------------------------------------
wire [BTB_ADDR_WIDTH-1:0] btb_addr_f;
wire [BTB_ADDR_WIDTH-1:0] btb_addr_e;
//--Registers-----------------------------------------------------------------
reg [1:0] GHR;
/*
* Branch Target Buffer
*   = {branch_pc[31:0], predict_pc[31:0], predict_state[1:0]}
*/
reg [ADDR_WIDTH-1:0] branch_pc [0:BHT_DEPTH-1];
reg [ADDR_WIDTH-1:0] predict_pc [0:BHT_DEPTH-1];
reg [1:0] predict_state [0:BHT_DEPTH-1] [0:3];
//--Assignments---------------------------------------------------------------
assign btb_addr_f = pc_f[BTB_ADDR_WIDTH-1:0];
assign btb_addr_e = pc_e[BTB_ADDR_WIDTH-1:0];

integer i, j;
initial begin
	GHR <= 2'b00;
	branchfound_f <= 0; predict_pc_f <= 0; mispredict_pc_e <= 0;
	for (i = 0; i < BHT_DEPTH; i = i + 1) begin
		{branch_pc[i], predict_pc[i]} <= 'bx;
		for (j = 0; j < 4; j = j + 1) begin
			predict_state[i][j] <= 'bx;
		end
	end
end

always @(branch_found_EXE or pc_f or branch_taken_EXE) begin


	//if (pc_f == branch_pc[btb_addr_f] && btb_addr_f != 0) begin
	if (pc_f === branch_pc[btb_addr_f]) begin
		predict_pc_f <= predict_pc[btb_addr_f];
		branchfound_f <= 1;
	end else begin
		predict_pc_f <= pc_f + 4;
		branchfound_f <= 0;
	end

/*	if (branch_taken_EXE)
		GHR <= {1'b1, GHR[1]};
	else
		GHR <= {1'b0, GHR[1]};
*/	

	if (~branch_found_EXE & branch_taken_EXE) begin
		mispredict_pc_e <= pcbranch_e;
		branch_pc[btb_addr_e] <= pc_e;
		predict_pc[btb_addr_e] <= pcbranch_e;
		predict_state[btb_addr_e][GHR] <= 2'b00;
		$display("~branch_found_EXE & branch_taken_EXE, 01, time is %0t", $time);
		$display("branch_pc[%d] = %d", btb_addr_e, branch_pc[btb_addr_e]);
		$display("predict_pc[%d] = %d", btb_addr_e, predict_pc[btb_addr_e]);
		$display("predict_state[%d][%b] = 00", btb_addr_e, GHR);
	end
	else if (branch_found_EXE & ~branch_taken_EXE) begin
		mispredict_pc_e <= pc_e + 4;
		$display("branch_found_EXE & ~branch_taken_EXE, 10, time is %0t", $time);
		if (predict_state[btb_addr_e][GHR] != 2'b00) begin
			predict_state[btb_addr_e][GHR] <= predict_state[btb_addr_e][GHR]-1;
			end
	end
	else if (branch_found_EXE & branch_taken_EXE) begin
		$display("branch_found_EXE & branch_taken_EXE, 11, time is %0t", $time);
		if (predict_state[btb_addr_e][GHR] != 2'b11) begin
			predict_state[btb_addr_e][GHR] <= predict_state[btb_addr_e][GHR]+1;
			end
	end
	
end

always@(branch_found_EXE) begin
	if(branch_taken_EXE)
	GHR <= {GHR[1], 1'b1};
	else
	GHR <= {GHR[1], 1'b0};
end

endmodule

/*
always @(*) begin

	predict_pc_f = pc_f + 4;
	branchfound_f = 0;
	if (pc_f === branch_pc[btb_addr_f]) begin
		branchfound_f = 1;
		if (branch_pc[btb_addr_f][GHR] === 2'b1x)
			predict_pc_f = predict_pc[btb_addr_f];
		else
			predict_pc_f = pc_f + 4;
	end else begin
		predict_pc_f = pc_f + 4;
		branchfound_f = 0;
	end

	if (~branch_found_EXE & branch_taken_EXE) begin
		mispredict_pc_e = pcbranch_e;
		branch_pc[btb_addr_e] = pc_e;
		predict_pc[btb_addr_e] = pcbranch_e;
		predict_state[btb_addr_e][GHR] = 2'b00;
		GHR = {1'b1, GHR[1]};
	end
	else if (branch_found_EXE & ~branch_taken_EXE) begin
		mispredict_pc_e = pc_e + 4;
		if (predict_state[btb_addr_e][GHR] != 2'b00)
			predict_state[btb_addr_e][GHR] = predict_state[btb_addr_e][GHR]-1;
		GHR = {1'b0, GHR[1]};
	end
	else if (branch_found_EXE & branch_taken_EXE) begin
		if (predict_state[btb_addr_e][GHR] != 2'b11)
			predict_state[btb_addr_e][GHR] = predict_state[btb_addr_e][GHR]+1;
		GHR = {1'b1, GHR[1]};
	end
end
*/

