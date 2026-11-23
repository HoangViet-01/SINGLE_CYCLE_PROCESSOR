module top_controller (
	input logic clk,
	input logic [3:0] Cond,
	input logic [1:0] Op,
	input logic [5:0] Funct,
	input logic [3:0] Rd,
	input logic [3:0] Flags,
	
	output logic PCSrc,
	output logic MemtoReg,
	output logic MemWrite,
	output logic [3:0] ALUControl,
	output logic ALUSrc,
	output logic [1:0] ImmSrc,
	output logic RegWrite,
	output logic [1:0] RegSrc
);

	logic PCS;
	logic RegW;
	logic MemW;
	logic [1:0] FlagsW;
	logic NotWrite;
	
	/* Decoder */
	Decoder decoder_uut (
		.Op(Op), // bit Instr[27:26].
		.Funct(Funct), // bit Instr[25:20].
		.Rd(Rd), // bit Insr[15:12].
		.PCS(PCS),
		.RegW(RegW),
		.MemW(MemW),
		.MemtoReg(MemtoReg),
		.ALUSrc(ALUSrc),
		.ImmSrc(ImmSrc),
		.RegSrc(RegSrc),
		.ALUControl(ALUControl),
		.FlagsW(FlagsW),
		.NotWrite(NotWrite)
	);
	
	/* Consditional logic */
	Conditional_Logic conditional_logic_uut (
		.clk(clk),
		.PCS(PCS),
		.RegW(RegW),
		.MemW(MemW),
		.FlagsW(FlagsW),
		.Cond(Cond),
		.ALUFlags(Flags),
		.PCSrc(PCSrc),
		.RegWrite(RegWrite),
		.MemWrite(MemWrite),
		.NotWrite(NotWrite)
	);

endmodule