module ALU_Decoder (
	input logic ALUOp,
	input logic [3:0] cmd,
	input logic S,
	output logic [3:0] ALUControl,
	output logic [1:0] FlagsW,
	output logic NotWrite
);

	always_comb begin
		NotWrite = 1'b0;
		FlagsW = 2'b0;
		ALUControl = 4'b0;
		
		if (ALUOp) begin
			case ({cmd, S}) 
				5'b0100_0 : begin // ADD.
					ALUControl = 4'b0;
					FlagsW = 2'b0;
				end
				5'b0100_1 : begin // ADDS.
					ALUControl = 4'b0;
					FlagsW = 2'b11;
				end
				
				5'b0010_0 : begin // SUB.
					ALUControl = 4'b0001;
					FlagsW = 2'b0;
				end
				5'b0010_1 : begin // SUBS.
					ALUControl = 4'b0001;
					FlagsW = 2'b11;
				end
				
				5'b0000_0 : begin // AND.
					ALUControl = 4'b0010;
					FlagsW = 2'b0;
				end
				5'b0000_1 : begin // AND co Flag : n, z.
					ALUControl = 4'b0010;
					FlagsW = 2'b10;
				end
				
				5'b1100_0 : begin // ORR.
					ALUControl = 4'b0011;
					FlagsW = 2'b0;
				end
				5'b1100_1 : begin // ORR co Flag : n, z.
					ALUControl = 4'b0011;
					FlagsW = 2'b10;
				end
				
				5'b1010_1 : begin // CMP co 4 co Flag.
					ALUControl = 4'b0001;
					FlagsW = 2'b11;
					NotWrite = 1'b1;
				end
				
				5'b1101_0 : begin // MOV.
					ALUControl = 4'b0100;
					FlagsW = 2'b00;
				end
				
				5'b1000_1 : begin // Lenh TST : thuc hien data_in1 AND data_in2 (hoac hang so)
					ALUControl = 4'b0010;
					FlagsW = 2'b10;
					NotWrite = 1'b1;
				end
				
				5'b1001_1 : begin // Lenh TEQ : thuc hien data_in1 XOR data_in2 (hoac hang so)
					ALUControl = 4'b0101;
					FlagsW = 2'b10;
					NotWrite = 1'b1;
				end
				
				default: begin
					ALUControl = 4'b0000;
					FlagsW = 2'b00;
					NotWrite = 1'b0;
				end
			endcase
		end
	end

endmodule