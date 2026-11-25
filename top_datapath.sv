module top_datapath #(
	parameter int WIDTH = 32,
	parameter int ADDR_WIDTH = 32,
	parameter int DATA_WIDTH = 32,
	parameter int SIZE = 512
) (
	input logic clk,
	input logic rst,
   input logic [WIDTH - 1:0] Instr,
	input logic PCSrc,
	input logic MemtoReg,
//	input logic MemWrite,
	input logic [3:0] ALUControl,
	input logic ALUSrc,
	input logic [1:0] ImmSrc,
	input logic RegWrite,
	input logic [1:0] RegSrc,
	input logic [WIDTH - 1:0] ReadData,
	
	output logic [WIDTH - 1:0] PC,
	output logic [WIDTH - 1:0] WriteData,
//	output logic [WIDTH - 1:0] Instr,
	output logic [3:0] ALUFlags,
	output logic [WIDTH - 1:0] ALUResult
);

	logic [WIDTH - 1:0] /*PC,*/ PC_next, PCPlus4, PCPlus8;
	logic [3:0] RA1, RA2;
	logic [WIDTH - 1:0] RD1, RD2;
	logic [WIDTH - 1:0] ExtImm;
	logic [WIDTH - 1:0] input_SrcB;
	logic [WIDTH - 1:0] SrcB;
//	logic [WIDTH - 1:0] ReadData;
	logic [WIDTH - 1:0] Result;
	
	/* --- PC --- */
	// Mux PC.
	MUX_21 #(
		.WIDTH(WIDTH)
	) pc_uut (
		.select(PCSrc),
		.data_in1(Result),
		.data_in2(PCPlus4),
		.data_out(PC_next)
	);
	
	// PC Reg.
	PC_reg pc_reg_uut (
		.clk(clk),
		.rst(rst),
		.pc_next(PC_next),
		.pc(PC)
	);
	// PCPlus4.
	ADD #(
		.WIDTH(WIDTH)
	) pcplus4_uut (
		.data_in1(PC),
		.data_in2(32'd4),
		.data_out(PCPlus4)
	);
	
	// PCPlus8.
	ADD #(
		.WIDTH(WIDTH)
	) pcplus8_uut (
		.data_in1(PCPlus4),
		.data_in2(32'd4),
		.data_out(PCPlus8)
	);
	
//	/* --- Instruction Memory --- */
//	Instr_Mem #(
//		.ADDR_WIDTH(ADDR_WIDTH),
//		.DATA_WIDTH(DATA_WIDTH),
//		.INSTR_SIZE(SIZE)
//	) instr_mem_uut (
//		.A(PC),
//		.RD(Instr)
//	);
	
	/* --- Register File --- */
	// Tinh RA1.
	MUX_21 #(
		.WIDTH(4)
	) ra1_uut (
		.select(RegSrc[0]),
		.data_in1(4'b1111),
		.data_in2(Instr[19:16]),
		.data_out(RA1)
	);
	
	// Tinh RA2.
	MUX_21 #(
		.WIDTH(4)
	) ra2_uut (
		.select(RegSrc[1]),
		.data_in1(Instr[15:12]),
		.data_in2(Instr[3:0]),
		.data_out(RA2)
	);
	
	// Register File.
	Register_File reg_file_uut (
		.clk(clk),
		.WE3(RegWrite),
		.A1(RA1),
		.A2(RA2),
		.A3(Instr[15:12]),
		.WD3(Result),
		.R15(PCPlus8),
		.RD1(RD1), // SrcA.
		.RD2(WriteData)
	);
	
	/* --- Extend --- */
	Extend_32bit extend_uut (
		.ImmSrc(ImmSrc),
		.Instr(Instr[23:0]),
		.ExtImm(ExtImm)
	);
	
	/* --- Shift --- */
	Shift #(
		.WIDTH(WIDTH)
	) shift_uut (
		.data_in(WriteData),
		.control(Instr[11:5]),
		.data_out(input_SrcB)
	);
	
	/* --- ALU --- */
	// Mux SrcB.
	MUX_21 #(
		.WIDTH(WIDTH)
	) srcb_uut (
		.select(ALUSrc),
		.data_in1(ExtImm),
		.data_in2(input_SrcB),
		.data_out(SrcB)
	);
	
	// ALU.
	ALU #(
		.WIDTH(WIDTH)
	) alu_uut (
		.ALUControl(ALUControl),
		.data_in1(RD1),
		.data_in2(SrcB),
		.data_out(ALUResult),
		.ALUFlags(ALUFlags)
	);
	
//	/* --- Data Memory --- */
//	// Data_Mem.
//	Data_Mem #(
//		.ADDR_WIDTH(ADDR_WIDTH),
//		.DATA_WIDTH(DATA_WIDTH),
//		.MEM_SIZE(SIZE)
//	) data_mem_uut (
//		.clk(clk),
//		.WE(MemWrite),
//		.A(ALUResult),
//		.WD(RD2), // WriteData.
//		.RD(ReadData)
//	);
	
	// Mux Result.
	MUX_21 #(
		.WIDTH(WIDTH)
	) result_uut (
		.select(MemtoReg),
		.data_in1(ReadData),
		.data_in2(ALUResult),
		.data_out(Result)
	);

endmodule