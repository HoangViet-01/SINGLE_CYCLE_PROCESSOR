`timescale 1ns/1ps

module tb_ALU;
    parameter int WIDTH = 32;

    // Khai báo các tín hiệu ngõ vào (inputs)
    logic [WIDTH - 1:0] data_in1;
    logic [WIDTH - 1:0] data_in2;
    logic [3:0]         alu_control;

    // Khai báo các tín hiệu ngõ ra (outputs)
    logic [WIDTH - 1:0] data_out;
    logic [3:0]         flags; // {N, Z, C, V}

    // Khởi tạo (Instantiate) module ALU cần test với tên cổng khớp chuẩn trong ALU.sv
    ALU #(
        .WIDTH(WIDTH)
    ) uut (
        .data_in1(data_in1),
        .data_in2(data_in2),
        .ALUControl(alu_control),    
        .data_out(data_out),
        .ALUFlags(flags)           
    );

    initial begin
        // Tạo file dump dạng sóng để xem trên GTKWave hoặc ModelSim (nếu cần)
        $dumpfile("tb_ALU.vcd");
        $dumpvars(0, tb_ALU);

        $display("=== BAT DAU KIEM TRA ALU ===");

        // 1. Test phép ADD (5 + 3 = 8)
        data_in1    = 32'd5;
        data_in2    = 32'd3;
        alu_control = 4'b0000; // ADD
        #10;
        $display("ADD: %0d + %0d = %0d | Flags (NZCV): %b", data_in1, data_in2, data_out, flags);

        // 2. Test phép SUB (10 - 4 = 6)
        data_in1    = 32'd10;
        data_in2    = 32'd4;
        alu_control = 4'b0001; // SUB
        #10;
        $display("SUB: %0d - %0d = %0d | Flags (NZCV): %b", data_in1, data_in2, data_out, flags);

        // 3. Test cờ Zero (5 - 5 = 0, cờ Z phải lên 1)
        data_in1    = 32'd5;
        data_in2    = 32'd5;
        alu_control = 4'b0001; // SUB
        #10;
        $display("SUB (Zero test): %0d - %0d = %0d | Flags (NZCV): %b", data_in1, data_in2, data_out, flags);

        // 4. Test phép AND (0x0F & 0x33)
        data_in1    = 32'h0F;
        data_in2    = 32'h33;
        alu_control = 4'b0010; // AND
        #10;
        $display("AND: %h & %h = %h | Flags (NZCV): %b", data_in1, data_in2, data_out, flags);

        // 5. Test phép OR (0x0F | 0x33)
        data_in1    = 32'h0F;
        data_in2    = 32'h33;
        alu_control = 4'b0011; // OR
        #10;
        $display("OR:  %h | %h = %h | Flags (NZCV): %b", data_in1, data_in2, data_out, flags);

        // 6. Test phép XOR
        data_in1    = 32'hFF00;
        data_in2    = 32'h0FF0;
        alu_control = 4'b0100; // XOR
        #10;
        $display("XOR: %h ^ %h = %h | Flags (NZCV): %b", data_in1, data_in2, data_out, flags);

        // 7. Test dịch trái LSL (4 << 2 = 16)
        data_in1    = 32'd4;
        data_in2    = 32'd2; // Số lượng dịch
        alu_control = 4'b1000; // LSL
        #10;
        $display("LSL: %0d << %0d = %0d | Flags (NZCV): %b", data_in1, data_in2[4:0], data_out, flags);

        // 8. Test dịch phải LSR (8 >> 1 = 4)
        data_in1    = 32'd8;
        data_in2    = 32'd1;
        alu_control = 4'b1001; // LSR
        #10;
        $display("LSR: %0d >> %0d = %0d | Flags (NZCV): %b", data_in1, data_in2[4:0], data_out, flags);

        $display("=== HOAN THANH KIEM TRA ALU ===");
        $finish;
    end

endmodule