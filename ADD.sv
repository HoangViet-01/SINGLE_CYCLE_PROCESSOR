module ADD # (
	parameter int WIDTH = 32
)(
	input logic [WIDTH - 1:0] data_in1,
	input logic [WIDTH - 1:0] data_in2,
	output logic [WIDTH - 1:0] data_out
);

	assign data_out = data_in1 + data_in2;

endmodule