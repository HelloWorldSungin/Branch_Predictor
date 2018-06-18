
/*
* Instruction Memory:
*/
module inst_memory (
	address,
	read_data
);
//--Input Ports-----
input [31:0] address;
//--Output Ports----
output [31:0] read_data;

/*-------------------------
*
*/
reg [31:0] RAM [255:0];

//initial $readmemh("hazard_test.mem", RAM);
//initial $readmemh("lwstall_test.mem", RAM);
//initial $readmemh("bubblesort.mem", RAM);
initial $readmemh("nestedFor.mem", RAM);

assign read_data = RAM[address[31:2]];

endmodule

