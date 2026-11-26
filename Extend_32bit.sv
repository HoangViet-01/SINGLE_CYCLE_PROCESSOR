module Extend_32bit (
	input logic [23:0] Instr,
	input logic [1:0] ImmSrc,
	output logic [31:0] ExtImm
);

	always_comb begin
		ExtImm = '0;
		casex (ImmSrc) 
			// 8-bit : Cac lenh lien qua den DP.
			2'b00 : ExtImm = {24'b0, Instr[7:0]};
			
			//12-bit : Cac lenh lien quan den Memory.
			2'b01 : ExtImm = {20'b0, Instr[11:0]};
			
			// 24-bit : Cac lenh lien quan den Branch.
			// offset = Instr x 4 (dich trai 2 bit) <-> LDR R2, [R0, R1, LSL #2] -> Doi tu offset logic sang offset thuc te.
			2'b10 : ExtImm = {{6{Instr[23]}}, Instr[23:0], 2'b00}; // Mo rong co dau va dich trai 2 bit.
			
			default : ExtImm = 32'bx;
		endcase
	end

endmodule