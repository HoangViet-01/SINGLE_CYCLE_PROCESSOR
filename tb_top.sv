`timescale 1ns/1ps

module tb_top;

    // 1. Các chân giao tiếp chính của module top
    logic clk;
    logic reset;
    logic [31:0] WriteData;
    logic [31:0] DataAdr;
    logic MemWrite;

    // Điều chỉnh 2 địa chỉ này cho khớp với file imem bạn đang nạp
    localparam logic [31:0] ADDR_LDR    = 32'h00000050; // Địa chỉ lệnh LDR trong bản imem đầy đủ
    localparam logic [31:0] ADDR_BRANCH = 32'h00000054; // Địa chỉ lệnh B 0x00 trong bản imem đầy đủ
    localparam logic [31:0] EXP_MEM_VAL = 32'd8;        // Giá trị kỳ vọng ghi vào Mem[4]

    top dut (
        .clk       (clk),
        .rst       (reset),
        .WriteData (WriteData),
        .DataAdr   (DataAdr),
        .MemWrite  (MemWrite)
    );

    // 2. Tín hiệu nội bộ để theo dõi trên Waveform
    logic [31:0] PC, Instr, ReadData;
    assign PC = dut.PC;
    assign Instr = dut.Instr;
    assign ReadData = dut.ReadData;

    logic [3:0]  ALUFlags, ALUControl;
    logic [1:0]  ImmSrc, RegSrc;
    logic        RegWrite, ALUSrc, MemtoReg, PCSrc, NotWrite;
    
    assign ALUControl = dut.cpu_uut.controller_uut.ALUControl;
    assign ImmSrc = dut.cpu_uut.controller_uut.ImmSrc;
    assign RegSrc = dut.cpu_uut.controller_uut.RegSrc;
    assign RegWrite = dut.cpu_uut.controller_uut.RegWrite;
    assign ALUSrc = dut.cpu_uut.controller_uut.ALUSrc;
    assign MemtoReg = dut.cpu_uut.controller_uut.MemtoReg;
    assign PCSrc = dut.cpu_uut.controller_uut.PCSrc;
    assign NotWrite = dut.cpu_uut.controller_uut.NotWrite;

    logic [31:0] SrcA, SrcB, Result;
    assign SrcA = dut.cpu_uut.datapath_uut.alu_uut.data_in1;
    assign SrcB = dut.cpu_uut.datapath_uut.SrcB;
	 assign ALUFlags = dut.cpu_uut.datapath_uut.ALUFlags;
    assign Result = dut.cpu_uut.datapath_uut.Result;

    // Quan sát R0 -> R12
    logic [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12;
    assign R0  = dut.cpu_uut.datapath_uut.reg_file_uut.rf[0];
    assign R1  = dut.cpu_uut.datapath_uut.reg_file_uut.rf[1];
    assign R2  = dut.cpu_uut.datapath_uut.reg_file_uut.rf[2];
    assign R3  = dut.cpu_uut.datapath_uut.reg_file_uut.rf[3];
    assign R4  = dut.cpu_uut.datapath_uut.reg_file_uut.rf[4];
    assign R5  = dut.cpu_uut.datapath_uut.reg_file_uut.rf[5];
    assign R6  = dut.cpu_uut.datapath_uut.reg_file_uut.rf[6];
    assign R7  = dut.cpu_uut.datapath_uut.reg_file_uut.rf[7];
    assign R8  = dut.cpu_uut.datapath_uut.reg_file_uut.rf[8];
    assign R9  = dut.cpu_uut.datapath_uut.reg_file_uut.rf[9];
    assign R10 = dut.cpu_uut.datapath_uut.reg_file_uut.rf[10];
    assign R11 = dut.cpu_uut.datapath_uut.reg_file_uut.rf[11];
    assign R12 = dut.cpu_uut.datapath_uut.reg_file_uut.rf[12];

    // 3. Clock chu kỳ 10ns
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // 4. Reset và timeout an toàn (đủ cho chương trình dài ~24 lệnh)
    initial begin
        reset = 1'b1;
        #22;
        reset = 1'b0;

        #1000;
        $display("TIMEOUT: Mo phong vuot qua thoi gian cho phep!");
        $finish;
    end

    // 5. Kiểm tra ghi RAM, đọc LDR, nhánh và in log từng bước
    bit ldr    = 1'b0;
    bit branch = 1'b0;

    always @(negedge clk) begin
        if (!reset) begin
            $display("[t=%0t ns] PC=0x%08h Instr=0x%08h PCSrc=%b Z=%b R3=%0d R4=%0d R6=%0d R11=%0d",
                     $time, PC, Instr, PCSrc, ALUFlags[2], R3, R4, R6, R11);

            // Kiểm tra ghi bộ nhớ (STR)
            if (MemWrite) begin
                $display("  -> Ghi RAM: Dia chi = 0x%08h (%0d) | Du lieu = %0d",
                         DataAdr, DataAdr, WriteData);
                if (DataAdr === 32'd4) begin
                    assert (WriteData === EXP_MEM_VAL)
                        else $error("LOI GHI MEM[4]: Ky vong %0d, nhan duoc %0d", EXP_MEM_VAL, WriteData);
                end else begin
                    $error("LOI: Ghi vao dia chi khong xac dinh 0x%08h!", DataAdr);
                end
            end

            // Kiểm tra sau lệnh LDR
            if (ldr) begin
                // Trong bản imem đầy đủ, LDR ghi vào R11; nếu dùng bản cũ thì R4
                assert (R11 === EXP_MEM_VAL || R4 === 32'd2)
                    else $error("LOI LDR: Ky vong gia tri nap = %0d (R11=%0d, R4=%0d)", EXP_MEM_VAL, R11, R4);
                ldr = 1'b0;
            end
            if (PC === ADDR_LDR) begin
                ldr = 1'b1;
            end

            // Kiểm tra sau lệnh nhánh B 0x00
            if (branch) begin
                assert (PC === 32'h00000000)
                    else $error("LOI BRANCH: Ky vong PC = 0x00000000, nhan duoc 0x%08h", PC);
                $display("=== THANH CONG: CPU da chay het chuong trinh va nhay ve 0x00000000! ===");
                #20;
                $finish;
            end
            if (PC === ADDR_BRANCH) begin
                branch = 1'b1;
            end
        end
    end

endmodule