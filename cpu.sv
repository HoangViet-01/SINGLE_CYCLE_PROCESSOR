module cpu #(
	parameter int WIDTH = 32,
	parameter int ADDR_WIDTH = 32,
	parameter int DATA_WIDTH = 32,
	parameter int SIZE = 512
) (
	input  logic clk,
	input  logic rst,
	input  logic [WIDTH - 1:0] Instr,
	input  logic [WIDTH - 1:0] ReadData,

	output logic [WIDTH - 1:0] PC,
	output logic MemWrite,
	output logic [WIDTH - 1:0] ALUResult,
	output logic [WIDTH - 1:0] WriteData
//	output logic [3:0] ALUFlags
);

	logic PCSrc;
	logic MemtoReg;
	logic [3:0] ALUControl;
	logic ALUSrc;
	logic [1:0] ImmSrc;
	logic RegWrite;
	logic [1:0] RegSrc;

	// Datapath.
	top_datapath #(
		.WIDTH(WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH),
		.SIZE(SIZE)
	) datapath_uut (
		.clk(clk),
		.rst(rst),
		.PCSrc(PCSrc),
		.MemtoReg(MemtoReg),
//		.MemWrite(MemWrite),
		.ALUControl(ALUControl),
		.ALUSrc(ALUSrc),
		.ImmSrc(ImmSrc),
		.RegWrite(RegWrite),
		.RegSrc(RegSrc),
		.Instr(Instr),
		.ReadData(ReadData),
		.PC(PC),
		.ALUResult(ALUResult),
		.WriteData(WriteData),
		.ALUFlags(ALUFlags)
	);

	// Controller.
	top_controller controller_uut (
		.clk(clk),
		.Cond(Instr[31:28]),
		.Op(Instr[27:26]),
		.Funct(Instr[25:20]),
		.Rd(Instr[15:12]),
		.Flags(ALUFlags),
		.PCSrc(PCSrc),
		.MemtoReg(MemtoReg),
		.MemWrite(MemWrite),
		.ALUControl(ALUControl),
		.ALUSrc(ALUSrc),
		.ImmSrc(ImmSrc),
		.RegWrite(RegWrite),
		.RegSrc(RegSrc)
	);
endmodule