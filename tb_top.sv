`timescale 1ns/1ps

module tb_top;

    // 1. Các chân giao tiếp chính của module top
    logic clk;
    logic reset;
    logic [31:0] WriteData;
    logic [31:0] DataAdr;
    logic MemWrite;

    // Khởi tạo DUT (giữ nguyên top.sv gốc, không cần sửa port)
    top dut (
        .clk (clk),
        .rst (reset),
        .WriteData (WriteData),
        .DataAdr (DataAdr),
        .MemWrite (MemWrite)
    );

    // 2. MÓC THẲNG TÍN HIỆU NỘI BỘ (HIERARCHICAL REFERENCE) ĐỂ XEM TRÊN WAVE
    // --- Tín hiệu giữa CPU với IMEM / DMEM ---
    logic [31:0] PC, Instr, ReadData;
    assign PC = dut.PC;
    assign Instr = dut.Instr;
    assign ReadData = dut.ReadData;

    // --- Tín hiệu khối Controller & Cờ trạng thái ---
    logic [3:0]  ALUFlags, Flags;
    logic [3:0]  ALUControl;
    logic [1:0]  ImmSrc, RegSrc;
    logic RegWrite, ALUSrc, MemtoReg, PCSrc, NotWrite;
    assign ALUFlags   = dut.ALUFlags;
    assign Flags = dut.ALUFlags;
    assign ALUControl = dut.cpu_uut.controller_uut.ALUControl;
    assign ImmSrc = dut.cpu_uut.controller_uut.ImmSrc;
    assign RegSrc = dut.cpu_uut.controller_uut.RegSrc;
    assign RegWrite = dut.cpu_uut.controller_uut.RegWrite;
    assign ALUSrc = dut.cpu_uut.controller_uut.ALUSrc;
    assign MemtoReg = dut.cpu_uut.controller_uut.MemtoReg;
    assign PCSrc = dut.cpu_uut.controller_uut.PCSrc;
    assign NotWrite = dut.cpu_uut.controller_uut.NotWrite;

    // --- Tín hiệu bên trong Datapath (Toán hạng ALU & Kết quả) ---
    logic [31:0] SrcA, SrcB, Result;
    assign SrcA   = dut.cpu_uut.datapath_uut.alu_uut.data_in1;
    assign SrcB   = dut.cpu_uut.datapath_uut.SrcB;
    assign Result = dut.cpu_uut.datapath_uut.Result;

    // --- Quan sát trực tiếp các thanh ghi R0 -> R8 trong Register File ---
    logic [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8;
    assign R0 = dut.cpu_uut.datapath_uut.reg_file_uut.rf[0];
    assign R1 = dut.cpu_uut.datapath_uut.reg_file_uut.rf[1];
    assign R2 = dut.cpu_uut.datapath_uut.reg_file_uut.rf[2];
    assign R3 = dut.cpu_uut.datapath_uut.reg_file_uut.rf[3];
    assign R4 = dut.cpu_uut.datapath_uut.reg_file_uut.rf[4];
    assign R5 = dut.cpu_uut.datapath_uut.reg_file_uut.rf[5];
    assign R6 = dut.cpu_uut.datapath_uut.reg_file_uut.rf[6];
    assign R7 = dut.cpu_uut.datapath_uut.reg_file_uut.rf[7];
    assign R8 = dut.cpu_uut.datapath_uut.reg_file_uut.rf[8];

    // 3. Tạo xung clock chu kỳ 10ns
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // 4. Kịch bản cấp Reset và giới hạn thời gian
    initial begin
        reset = 1'b1;
        #22;
        reset = 1'b0;

        #500;
        $display("TIMEOUT: Mo phong vuot qua thoi gian cho phep!");
        $finish;
    end

    // 5. Tự động kiểm tra kết quả ghi RAM, đọc LDR và nhảy nhánh B 0x00
    bit seen_ldr    = 1'b0;
    bit seen_branch = 1'b0;

    always @(negedge clk) begin
        if (!reset) begin
            if (MemWrite) begin
                $display("[Time %0t ns] Ghi RAM: Dia chi = %0d | Du lieu = %0d",
                         $time, DataAdr, WriteData);

                if (DataAdr === 32'd4) begin
                    assert (WriteData === 32'd2)
                        else $error("LOI GHI MEM[4]: Ky vong 2, nhan duoc %0d", WriteData);
                end else begin
                    $error("LOI: Ghi vao dia chi khong xac dinh %0d!", DataAdr);
                    $finish;
                end
            end

            // Kiểm tra lệnh LDR R4, [R0, #4] tại PC = 0x18
            if (PC === 32'h00000018) begin
                seen_ldr = 1'b1;
            end else if (seen_ldr) begin
                assert (R4 === 32'd2)
                    else $error("LOI LDR: Ky vong R4 = 2, nhan duoc %0d", R4);
                seen_ldr = 1'b0;
            end

            // Kiểm tra lệnh B 0x00 tại PC = 0x1C nhảy về 0x00000000
            if (seen_branch) begin
                assert (PC === 32'h00000000)
                    else $error("LOI BRANCH: Ky vong PC = 0x00000000, nhan duoc 0x%08h", PC);
                $display("=== THANH CONG: CPU da thuc thi dung toan bo tap lenh! ===");
                #20;
                $finish;
            end

            if (PC === 32'h0000001C) begin
                seen_branch = 1'b1;
            end
        end
    end

endmodule