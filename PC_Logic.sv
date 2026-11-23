module PC_Logic (
	input logic [3:0] Rd,
	input logic RegW,
	input logic Branch,
	output logic PCS
);
	// Khi cap nhat thanh ghi R15 (cho phep ghi : RegW = 1 va thanh ghi : Rd = 4'd15) 
	// Hoac khi co lenh re nhanh, ket qua duoc cap nhat la ket qua tu ALU hoac tu Dmem.
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;

endmodule