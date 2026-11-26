module top #(
	parameter int WIDTH = 32,
	parameter int ADDR_WIDTH = 32,
	parameter int DATA_WIDTH = 32,
	parameter int SIZE = 512
) (
	input logic clk,
	input logic rst,
	
	output [WIDTH - 1:0] WriteData,
	output [WIDTH - 1:0] DataAdr,
	output logic MemWrite
);
	logic [WIDTH - 1:0] PC;
	logic [WIDTH - 1:0] Instr;
	//logic MemWrite;
	//logic [WIDTH - 1:0] ALUResult;
	//logic [WIDTH - 1:0] WriteData;
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
		.ALUResult(DataAdr),
		.WriteData(WriteData),
		.ALUFlags(ALUFlags)
	);

	// Instruction Memory.
	Instr_Mem #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH),
		.INSTR_SIZE(64)
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
		.A(DataAdr),
		.WD(WriteData),
		.RD(ReadData)
	);
endmodule