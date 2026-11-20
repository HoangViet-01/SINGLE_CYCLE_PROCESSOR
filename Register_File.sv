module Register_File (
	input logic clk,
	input logic WE3,
	input logic [3:0] A1,
	input logic [3:0] A2,
	input logic [3:0] A3, // Luu dia chi thanh ghi ma WD3 luu data vao.
	input logic [31:0] WD3, // Chua data de luu vao dia chi do A3 dang chua.
	input logic [31:0] R15, // PC + 8.
	output logic [31:0] RD1,
	output logic [31:0] RD2
);

	logic [31:0] rf [0:14]; // 15 thanh ghi 32bit.
	
	always_ff @(posedge clk) begin
		if (WE3 && (A3 != 4'b1111)) rf[A3] <= WD3; // Lay data cua WD3 luu vao thanh ghi co dia chi la gia tri cua A3 != 15.
	end
	
	assign RD1 = (A1 == 4'b1111) ? R15 : rf[A1];
	assign RD2 = (A2 == 4'b1111) ? R15 : rf[A2];

endmodule