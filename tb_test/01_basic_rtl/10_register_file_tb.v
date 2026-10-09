`timescale 1ns/1ps
// 测试契约：同步写、异步双端口读、低有效异步复位、地址 0 恒为零且忽略写入。
// 覆盖：
//   1. 定向：复位清零、双端口读、x0 忽略写、wen=0 不写、异步读、异步复位；
//   2. 全地址写入后全地址读回（防地址间串扰）、同址连写最后一次生效；
//   3. 复位优先于同拍写（复位低电平跨过 posedge 时写入无效）；
//   4. 随机序列（300 拍）与黄金存储器模型比对，随机插入异步复位；
//   5. DATA_WIDTH=32/ADDR_WIDTH=5 参数化实例（含地址 31 边界）。
module tb_10_register_file;
    localparam integer DATA_WIDTH = 8;
    localparam integer ADDR_WIDTH = 3;
    reg clk, rst_n, wen;
    reg [ADDR_WIDTH-1:0] waddr, raddr1, raddr2;
    reg [DATA_WIDTH-1:0] wdata;
    wire [DATA_WIDTH-1:0] rdata1, rdata2;
    reg [DATA_WIDTH-1:0] model [0:(1 << ADDR_WIDTH) - 1];
    integer errors, address, i, seed, a;

    register_file #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) dut (
        .clk(clk), .rst_n(rst_n), .wen(wen), .waddr(waddr), .wdata(wdata),
        .raddr1(raddr1), .raddr2(raddr2), .rdata1(rdata1), .rdata2(rdata2)
    );
    always #5 clk = ~clk;

    // DATA_WIDTH=32 / ADDR_WIDTH=5 参数化实例（共享 clk/rst_n）。
    reg wen32;
    reg [4:0] waddr32, raddr132, raddr232;
    reg [31:0] wdata32;
    wire [31:0] rdata132, rdata232;
    reg [31:0] model32 [0:31];
    register_file #(.DATA_WIDTH(32), .ADDR_WIDTH(5)) dut32 (
        .clk(clk), .rst_n(rst_n), .wen(wen32), .waddr(waddr32), .wdata(wdata32),
        .raddr1(raddr132), .raddr2(raddr232), .rdata1(rdata132), .rdata2(rdata232)
    );

    task write_reg;
        input [ADDR_WIDTH-1:0] addr;
        input [DATA_WIDTH-1:0] value;
        begin
            @(negedge clk); wen = 1; waddr = addr; wdata = value;
            @(posedge clk); #1; wen = 0;
        end
    endtask

    task check_reads;
        input [ADDR_WIDTH-1:0] a1, a2;
        input [DATA_WIDTH-1:0] e1, e2;
        begin
            raddr1 = a1; raddr2 = a2; #1;
            if (rdata1 !== e1 || rdata2 !== e2) begin
                $display("[ERROR] read a1/a2=%0d/%0d expected=%h/%h actual=%h/%h",
                         a1, a2, e1, e2, rdata1, rdata2);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0; seed = 32'h0E6E_0010;
        clk = 0; rst_n = 0; wen = 0; waddr = 0; wdata = 0;
        raddr1 = 0; raddr2 = 0; wen32 = 0; waddr32 = 0; wdata32 = 0; raddr132 = 0; raddr232 = 0;
        for (address = 0; address < (1 << ADDR_WIDTH); address = address + 1)
            model[address] = 0;
        #2;
        for (address = 0; address < (1 << ADDR_WIDTH); address = address + 1)
            check_reads(address[ADDR_WIDTH-1:0], 0, 0, 0);
        rst_n = 1;

        write_reg(3, 8'hA5);
        write_reg(5, 8'h3C);
        model[3] = 8'hA5; model[5] = 8'h3C;
        check_reads(3, 5, 8'hA5, 8'h3C);
        check_reads(5, 3, 8'h3C, 8'hA5);

        // 写零号寄存器必须被忽略。
        write_reg(0, 8'hFF);
        check_reads(0, 3, 8'h00, 8'hA5);

        // wen=0 时即使地址和数据变化也不能写入。
        @(negedge clk); wen = 0; waddr = 3; wdata = 8'h77;
        @(posedge clk); #1; check_reads(3, 5, 8'hA5, 8'h3C);

        // 异步读：改变读地址，不等待时钟即可得到结果。
        @(negedge clk); check_reads(5, 0, 8'h3C, 8'h00);

        // 全地址写入后全地址读回，防地址间串扰。
        for (address = 1; address < (1 << ADDR_WIDTH); address = address + 1) begin
            write_reg(address[ADDR_WIDTH-1:0], {5'b0, address[ADDR_WIDTH-1:0]});
            model[address] = {5'b0, address[ADDR_WIDTH-1:0]};
        end
        for (address = 0; address < (1 << ADDR_WIDTH); address = address + 1)
            check_reads(address[ADDR_WIDTH-1:0], 0, model[address], 0);

        // 同址连写：最后一次生效。
        write_reg(4, 8'h11);
        write_reg(4, 8'h22);
        model[4] = 8'h22;
        check_reads(4, 4, 8'h22, 8'h22);

        // 复位优先于同拍写：复位低电平跨过 posedge 时写入无效。
        @(negedge clk); rst_n = 0; wen = 1; waddr = 4; wdata = 8'h99;
        @(posedge clk); #1;
        for (a = 0; a < (1 << ADDR_WIDTH); a = a + 1) model[a] = 0;
        check_reads(4, 0, 0, 0);
        wen = 0; rst_n = 1;

        // 随机序列 + 黄金模型。
        for (i = 0; i < 300; i = i + 1) begin
            @(negedge clk);
            wen    = $random(seed) & 1'b1;
            waddr  = $random(seed) & 3'b111;
            wdata  = $random(seed);
            raddr1 = $random(seed) & 3'b111;
            raddr2 = $random(seed) & 3'b111;
            if (($random(seed) & 32'h3F) == 0) begin
                rst_n = 0; #1;
                for (a = 0; a < (1 << ADDR_WIDTH); a = a + 1) model[a] = 0;
                if (rdata1 !== 0 || rdata2 !== 0) begin
                    $display("[ERROR] random reset: reads not cleared"); errors = errors + 1;
                end
                rst_n = 1;
            end
            @(posedge clk); #1;
            if (wen && waddr != 0) model[waddr] = wdata;
            if (rdata1 !== model[raddr1] || rdata2 !== model[raddr2]) begin
                $display("[ERROR] random wen/waddr/wdata=%b/%0d/%h exp=%h/%h act=%h/%h",
                         wen, waddr, wdata, model[raddr1], model[raddr2], rdata1, rdata2);
                errors = errors + 1;
            end
        end

        // WIDTH=32 实例：地址 31 边界、x0 忽略、双端口读、随机序列。
        rst_n = 0; #1;
        for (a = 0; a < 32; a = a + 1) model32[a] = 0;
        rst_n = 1;
        @(negedge clk); wen32 = 1; waddr32 = 5'd31; wdata32 = 32'hDEAD_BEEF;
        @(posedge clk); #1; wen32 = 0;
        model32[31] = 32'hDEAD_BEEF;
        raddr132 = 5'd31; raddr232 = 5'd0; #1;
        if (rdata132 !== 32'hDEAD_BEEF || rdata232 !== 32'h0) begin
            $display("[ERROR] W32 max-addr read %h/%h", rdata132, rdata232);
            errors = errors + 1;
        end
        @(negedge clk); wen32 = 1; waddr32 = 5'd0; wdata32 = 32'hFFFF_FFFF;
        @(posedge clk); #1; wen32 = 0;
        raddr132 = 5'd0; #1;
        if (rdata132 !== 32'h0) begin
            $display("[ERROR] W32 x0 write not ignored"); errors = errors + 1;
        end
        raddr132 = 5'd31; #1;
        if (rdata132 !== 32'hDEAD_BEEF) begin
            $display("[ERROR] W32 neighbor corrupted by x0 write"); errors = errors + 1;
        end
        for (i = 0; i < 50; i = i + 1) begin
            @(negedge clk);
            wen32    = $random(seed) & 1'b1;
            waddr32  = $random(seed) & 5'b11111;
            wdata32  = $random(seed);
            raddr132 = $random(seed) & 5'b11111;
            raddr232 = $random(seed) & 5'b11111;
            @(posedge clk); #1;
            if (wen32 && waddr32 != 0) model32[waddr32] = wdata32;
            if (rdata132 !== model32[raddr132] || rdata232 !== model32[raddr232]) begin
                $display("[ERROR] W32 random exp=%h/%h act=%h/%h",
                         model32[raddr132], model32[raddr232], rdata132, rdata232);
                errors = errors + 1;
            end
        end

        if (errors == 0) $display("[PASS] register file write/read/x0/reset, random golden-model + W32");
        else begin $display("[FAIL] register_file: %0d error(s)", errors); $fatal(1); end
        $finish;
    end
endmodule
