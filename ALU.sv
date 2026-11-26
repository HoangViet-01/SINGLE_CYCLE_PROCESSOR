module ALU #(
	parameter int WIDTH = 32
) (
	input logic [WIDTH - 1:0] data_in1,
	input logic [WIDTH - 1:0] data_in2,
	input logic [3:0] ALUControl,
	output logic [WIDTH - 1:0] data_out,
	output logic [3:0] ALUFlags
);

	logic n, z, c, v;
	logic [WIDTH:0] add_sub_ext; // Bien dung de tinh phep add/sub va bit c/v.
	
	always_comb begin
		data_out = '0;
		add_sub_ext = '0;
		c = 1'b0;
		v = 1'b0;
		case (ALUControl) 
			// ADD.
			4'b0000 : begin 
				add_sub_ext = {1'b0, data_in1} + {1'b0, data_in2};
				data_out = add_sub_ext[WIDTH - 1:0];
				c = add_sub_ext[WIDTH];
				v = ~(data_in1[WIDTH - 1] ^ data_in2[WIDTH - 1]) & (data_in1[WIDTH - 1] ^ data_out[WIDTH - 1]);
			end
			// SUB.
			4'b0001 : begin
				add_sub_ext = {1'b0, data_in1} + {1'b0, ~data_in2} + 1;
				data_out = add_sub_ext[WIDTH - 1:0];
				c = ~add_sub_ext[WIDTH];
				v = (data_in1[WIDTH - 1] ^ data_in2[WIDTH - 1]) & (data_in1[WIDTH - 1] ^ data_out[WIDTH - 1]);
			end
			4'b0010 : data_out = data_in1 & data_in2; // AND.
			4'b0011 : data_out = data_in1 | data_in2; // OR.
			4'b0100 : data_out = data_in2; // Truyen thang data_in2 - lenh MOV.
			4'b0101 : data_out = data_in1 ^ data_in2; // XOR.
			
//			4'b0111 : data_out = data_in1; // Truyen thang data_in1.
//			4'b0110 : data_out = ~data_in1; // NOT.
//			4'b1000 : data_out = data_in1 << data_in2[4:0]; // LSL, 2^5 = 32bit.
//			4'b1001 : data_out = data_in1 >> data_in2[4:0]; // LSR.

			default : data_out = '0;
		endcase
		n = data_out[WIDTH - 1];
		z = (data_out == '0);
		ALUFlags = {n, z, c ,v}; // Gan co trang thai.
	end
endmodule