module Conditional_Logic (
	input logic clk,
	input logic PCS,
	input logic RegW,
	input logic MemW,
	input logic [1:0] FlagsW,
	input logic [3:0] Cond,
	input logic [3:0] ALUFlags,
	input logic NotWrite,
	
	output logic PCSrc,
	output logic RegWrite,
	output logic MemWrite
);

	logic [1:0] FlagWrite;
	logic CondEx;
	logic [1:0] Flags_32;
	logic [1:0] Flags_10;
	
	// Conditional Check.
	Condition_Check cond_check_uut (
		.Flags({Flags_32, Flags_10}),
		.Cond(Cond),
		.CondEx(CondEx)
	);
	
	assign FlagWrite = FlagsW & {2{CondEx}};
	
	// Dung FlagWrite lam rst cho Clock.
	always_ff @(posedge clk) begin
		if (FlagWrite[0]) begin
			Flags_10 <= ALUFlags[1:0]; // C, V.
		end
		if (FlagWrite[1]) begin
			Flags_32 <= ALUFlags[3:2]; // N , Z.
		end
	end
	
	// Cac dau ra dieu khien con lai.
	always_comb begin
		PCSrc = PCS & CondEx;
		RegWrite = RegW & CondEx & (~NotWrite);
		MemWrite = MemW & CondEx;
	end
	
endmodule