module Data_Mem #(
	parameter int ADDR_WIDTH = 32,
	parameter int DATA_WIDTH = 32,
	parameter int MEM_SIZE = 512 // Kich thuoc bo nho.
) (
	input logic clk,
	input logic WE,
	input logic [31:0] A,
	input logic [31:0] WD,
	output logic [31:0] RD
);

	logic [31:0] mem [0:MEM_SIZE - 1]; // 512 phan tu 32 bit.
	
	// WRITE : Luu gia tri tu WD vao mem khi WE = 1 (dong bo clk).
	always_ff @(posedge clk) begin
		if (WE) mem[A[10:2]] <= WD; // Lay A/4 ra index cua mem can luu.
	end
	
	// READ : doc gia tri tu mem ngay lap tuc (ko dong bo clk).
	assign RD = mem[A[10:2]]; // Doc gia tri tu index (tuong ung voi A/4) trong mem.
endmodule