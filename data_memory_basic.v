
/*
* Data Memory (Main Memory, DRAM):
*/




module data_memory_basic (
	clk,
	reset,
	wr_en,
	rd_en,
	addr,
	wr_data,
	rd_data
//	ready
);
//--Parameters----------------------------------------------------------------
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 32;
parameter RAM_DEPTH = 256;
//--Input Ports--------------
input clk, reset;
input wr_en, rd_en;
input [ADDR_WIDTH-1:0] addr;
input [DATA_WIDTH-1:0] wr_data;
//--Output Ports----------
output [31:0] rd_data;
//output reg [31:0] rd_data;
//output reg ready;

//--Registers-------------
reg [DATA_WIDTH-1:0] RAM [0:RAM_DEPTH-1];

/*
function rand;
input [31:0] min;
input [31:0] max;
rand = min + {$random} % (max - min);
endfunction
*/
initial $readmemb("descending_int.mem", RAM);
//initial $readmemb("ascending_int.mem", RAM);
//initial $readmemb("random_int.mem", RAM);
//integer i;
//initial for (i = 0; i < RAM_DEPTH; i=i+1) RAM[i] = i;


//assign rd_data = RAM[addr[31:2]]; // word aligned
assign rd_data = RAM[addr];

//--Synchronous----------------------
always @ (posedge clk or posedge reset) begin
	if (reset) begin end
	else begin
		if (wr_en) RAM[addr] <= wr_data;
	end
end//always
endmodule
