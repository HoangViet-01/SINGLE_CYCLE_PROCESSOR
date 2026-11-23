//module top # (
//	parameter int WIDTH = 32,
//	parameter int ADDR_WIDTH = 32,
//	parameter int DATA_WIDTH = 32,
//	parameter int SIZE = 512
//) (
//	input logic clk,
//	input logic rst
//);
//
////	logic [31:0] Instr;
////	logic [3:0] ALUFlags;
////	logic [31:0] ALUResult;
////	logic [31:0] ReadData;
////	
////	logic [WIDTH - 1:0] PC;
////	logic PCSrc;
////	logic MemtoReg;
////	logic MemWrite;
////	logic [3:0] ALUControl;
////	logic ALUSrc;
////	logic [1:0] ImmSrc;
////	logic RegWrite;
////	logic [1:0] RegSrc;
//
//	logic [WIDTH - 1:0] PC;
//	logic [WIDTH - 1:0] Instr;
//	logic [WIDTH - 1:0] ALUResult;
//	logic [WIDTH - 1:0] WriteData;
//	logic [WIDTH - 1:0] ReadData;
//	logic [3:0] ALUFlags;
//
//	// Control signals
//	logic PCSrc;
//	logic MemtoReg;
//	logic MemWrite;
//	logic [3:0] ALUControl;
//	logic ALUSrc;
//	logic [1:0] ImmSrc;
//	logic RegWrite;
//	logic [1:0] RegSrc;
//	
////	/* Datapath */
////	top_datapath #(
////		.WIDTH(WIDTH),
////		.ADDR_WIDTH(ADDR_WIDTH),
////		.DATA_WIDTH(DATA_WIDTH),
////		.SIZE(SIZE)
////	) datapath_uut (
////		.clk(clk),
////		.rst(rst),
////		.PCSrc(PCSrc),
////		.MemWrite(MemWrite),
////		.MemtoReg(MemtoReg),
////		.ALUControl(ALUControl),
////		.ALUSrc(ALUSrc),
////		.ImmSrc(ImmSrc),
////		.RegWrite(RegWrite),
////		.RegSrc(RegSrc),
////		.ReadData(ReadData),
////		.Instr(Instr),
////		.PC(PC),
////		.ALUResult(ALUResult),
////		.WriteData(WriteData),
////		.ALUFlags(ALUFlags)
////	);
////	
////	/* Controller */
////	top_controller controller_uut (
////		.clk(clk),
////		.Cond(Instr[31:28]),
////		.Op(Instr[27:26]),
////		.Funct(Instr[25:20]),
////		.Rd(Instr[15:12]),
////		.Flags(ALUFlags),
////		
////		.PCSrc(PCSrc),
////		.MemtoReg(MemtoReg),
////		.MemWrite(MemWrite),
////		.ALUControl(ALUControl),
////		.ALUSrc(ALUSrc),
////		.ImmSrc(ImmSrc),
////		.RegWrite(RegWrite),
////		.RegSrc(RegSrc)
////	);
//	
//	/* Instruction Memory */
//	Instr_Mem #(
//		.ADDR_WIDTH(ADDR_WIDTH),
//		.DATA_WIDTH(DATA_WIDTH),
//		.INSTR_SIZE(SIZE)
//	) instr_mem_uut (
//		.A(PC),
//		.RD(Instr)
//	);
//	
//	/* Data Memory */
//	Data_Mem #(
//		.ADDR_WIDTH(ADDR_WIDTH),
//		.DATA_WIDTH(DATA_WIDTH),
//		.MEM_SIZE(SIZE)
//	) data_mem_uut (
//		.clk(clk),
//		.WE(MemWrite),
//		.A(ALUResult),
//		.WD(WriteData),
//		.RD(ReadData)
//	);
//
//endmodule

module top #(
	parameter int WIDTH = 32,
	parameter int ADDR_WIDTH = 32,
	parameter int DATA_WIDTH = 32,
	parameter int SIZE = 512
) (
	input logic clk,
	input logic rst
);
	logic [WIDTH - 1:0] PC;
	logic [WIDTH - 1:0] Instr;
	logic MemWrite;
	logic [WIDTH - 1:0] ALUResult;
	logic [WIDTH - 1:0] WriteData;
	logic [WIDTH - 1:0] ReadData;
	logic [3:0] ALUFlags;

	// CPU.
	cpu #(
		.WIDTH(WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH),
		.SIZE(SIZE)
	) cpu_uut (
		.clk(clk),
		.rst(rst),
		.Instr(Instr),
		.ReadData(ReadData),
		.PC(PC),
		.MemWrite(MemWrite),
		.ALUResult(ALUResult),
		.WriteData(WriteData)
//		.ALUFlags(ALUFlags)
	);

	// Instruction Memory.
	Instr_Mem #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH),
		.INSTR_SIZE(SIZE)
	) instr_mem_uut (
		.A(PC),
		.RD(Instr)
	);

	// Data Memory.
	Data_Mem #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH),
		.MEM_SIZE(SIZE)
	) data_mem_uut (
		.clk(clk),
		.WE(MemWrite),
		.A(ALUResult),
		.WD(WriteData),
		.RD(ReadData)
	);
endmodule