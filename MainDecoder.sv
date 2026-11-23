module MainDecoder (
	input logic [1:0] Op,
	input logic Funct5,
	input logic Funct0,
	
	output logic Branch,
	output logic RegW,
	output logic MemW,
	output logic MemtoReg,
	output logic ALUSrc,
	output logic [1:0] ImmSrc,
	output logic [1:0] RegSrc,
	output logic ALUOp
);

	logic [9:0] controls; // {Branch, MemtoReg, MemW, ALUSrc, ImmSrc[1:0], RegW, RegSrc[1:0], ALUOp}.

	always_comb begin
		casex ({Op, Funct5, Funct0})
			// DP.
			4'b000? : controls = 10'b0_0_0_0_xx_1_00_1; // DP Reg.
			4'b001? : controls = 10'b0_0_0_1_00_1_x0_1; // DP Imm.
			// Mem.
			4'b01?0 : controls = 10'b0_x_1_1_01_0_10_0; // STR.
			4'b01?1 : controls = 10'b0_1_0_1_01_1_x0_0; // LDR.
			// Branch.
			4'b10?? : controls = 10'b1_0_0_1_10_0_x1_0; // B.
			default : controls = 10'bx;
		endcase
	end
	
	assign {Branch, MemtoReg, MemW, ALUSrc, ImmSrc[1:0], RegW, RegSrc[1:0], ALUOp} = controls;

endmodule