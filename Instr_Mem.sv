module Instr_Mem #(
	parameter int ADDR_WIDTH = 32,
	parameter int DATA_WIDTH = 32,
	parameter int INSTR_SIZE = 512 // So luong cau lenh.
) (
	input logic [ADDR_WIDTH - 1:0] A,
	output logic [DATA_WIDTH - 1:0] RD
);

	logic [DATA_WIDTH - 1:0] mem [0:INSTR_SIZE - 1]; // Mang INSTR_SIZE phan tu DATA_WIDTH bit luu NUM_INSTR cau lenh.
	
	// Doc tap lenh tu file rv32i_book.hex roi dua vao mang mem.
	initial begin
		$readmemh("rv32i_book.hex", mem);
	end
	
	// Tinh vi tri cau lenh trong mang mem(0,1,2,...) thong qua A(PC)(0x00,0x04,0x008,...).
	// Dich phai A 2 bit (lay A/4) de ra vi tri trong mem.
	assign RD = mem[A[31:2]];

endmodule