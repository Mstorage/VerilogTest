`timescale 1ns/1ps
// 测试契约：parity_even = 偶校验位（数据+校验位共偶数个 1）；error = 接收侧校验错误。
// 覆盖：
//   1. WIDTH=8 生成/检测穷举（256 组），校验位正确与翻转各测一次；
//   2. data 与 rx_data 解耦的随机测试（200 组）：parity_even 只依赖 data；
//   3. 校验器自检：逐位循环奇偶与规约异或交叉验证（不与被测逻辑共用运算符）；
//   4. 敏感列表：rx 侧变化不得影响 parity_even；
//   5. WIDTH=1 穷举与 WIDTH=32 随机参数化实例。
module tb_03_parity;
    localparam integer WIDTH = 8;
    reg  [WIDTH-1:0] data, rx_data;
    reg  rx_parity;
    wire parity_even, error;
    integer errors, value, i, seed;
    reg [31:0] v32;
    reg expected_parity;
    reg p_snapshot;

    parity_unit #(.WIDTH(WIDTH)) dut (
        .data(data), .rx_data(rx_data), .rx_parity(rx_parity),
        .parity_even(parity_even), .error(error)
    );

    // 参数化实例。
    reg  d1, r1, rp1;
    wire p1, e1;
    parity_unit #(.WIDTH(1)) dut1 (
        .data(d1), .rx_data(r1), .rx_parity(rp1), .parity_even(p1), .error(e1)
    );
    reg  [31:0] d32, r32;
    reg  rp32;
    wire p32, e32;
    parity_unit #(.WIDTH(32)) dut32 (
        .data(d32), .rx_data(r32), .rx_parity(rp32), .parity_even(p32), .error(e32)
    );

    // 独立于规约异或的逐位奇偶校验器，与被测逻辑不共用运算符。
    function parity_of;
        input [31:0] v;
        input integer bits;
        integer k;
        begin
            parity_of = 0;
            for (k = 0; k < bits; k = k + 1)
                parity_of = parity_of ^ v[k];
        end
    endfunction

    initial begin
        errors = 0; seed = 32'hCAFE_1234;
        data = 0; rx_data = 0; rx_parity = 0;

        // 校验器自检：与规约异或交叉验证，防止校验器自身带 bug。
        for (i = 0; i < 10; i = i + 1) begin
            v32 = $random(seed);
            if (parity_of(v32, 32) !== (^v32)) begin
                $display("[ERROR] checker self-check mismatch on %h", v32);
                errors = errors + 1;
            end
        end

        // 8 位穷举：生成与检测（rx_data=data）。
        for (value = 0; value < 256; value = value + 1) begin
            data = value[7:0];
            rx_data = value[7:0];
            expected_parity = parity_of({24'b0, value[7:0]}, WIDTH);
            rx_parity = expected_parity;
            #1;
            if (parity_even !== expected_parity || error !== 1'b0) begin
                $display("[ERROR] data=%h exp parity=%b act=%b error=%b",
                         data, expected_parity, parity_even, error);
                errors = errors + 1;
            end
            rx_parity = ~expected_parity;
            #1;
            if (error !== 1'b1) begin
                $display("[ERROR] flipped parity not detected for data=%h", data);
                errors = errors + 1;
            end
        end

        // 随机解耦：data 与 rx_data 相互独立，parity_even 只由 data 决定。
        for (i = 0; i < 200; i = i + 1) begin
            data = $random(seed);
            rx_data = $random(seed);
            rx_parity = $random(seed) & 1'b1;
            #1;
            if (parity_even !== parity_of({24'b0, data}, WIDTH)) begin
                $display("[ERROR] random gen data=%h exp=%b act=%b",
                         data, parity_of({24'b0, data}, WIDTH), parity_even);
                errors = errors + 1;
            end
            if (error !== (parity_of({24'b0, rx_data}, WIDTH) !== rx_parity)) begin
                $display("[ERROR] random detect rx=%h par=%b act error=%b", rx_data, rx_parity, error);
                errors = errors + 1;
            end
        end

        // 敏感列表：rx 侧变化不得影响 parity_even。
        data = 8'h55; rx_data = 8'h00; rx_parity = 1'b0;
        #1;
        p_snapshot = parity_even;
        rx_data = 8'hAA; rx_parity = 1'b1;
        #1;
        if (parity_even !== p_snapshot) begin
            $display("[ERROR] parity_even changed with only rx inputs");
            errors = errors + 1;
        end

        // WIDTH=1 穷举（8 种组合）。
        for (i = 0; i < 8; i = i + 1) begin
            d1 = i[0]; r1 = i[1]; rp1 = i[2];
            #1;
            if (p1 !== parity_of({31'b0, d1}, 1) ||
                e1 !== (parity_of({31'b0, r1}, 1) !== rp1)) begin
                $display("[ERROR] W1 d/r/rp=%b/%b/%b p/e=%b/%b", d1, r1, rp1, p1, e1);
                errors = errors + 1;
            end
        end

        // WIDTH=32 边界与随机（含全 0 / 全 1）。
        d32 = 32'h0000_0000; r32 = 32'hFFFF_FFFF; rp32 = parity_of(r32, 32); #1;
        if (p32 !== 1'b0 || e32 !== 1'b0) begin
            $display("[ERROR] W32 boundary p/e=%b/%b", p32, e32);
            errors = errors + 1;
        end
        for (i = 0; i < 100; i = i + 1) begin
            d32 = $random(seed);
            r32 = $random(seed);
            rp32 = parity_of(r32, 32);
            #1;
            if (p32 !== parity_of(d32, 32) || e32 !== 1'b0) begin
                $display("[ERROR] W32 random d=%h r=%h p/e=%b/%b", d32, r32, p32, e32);
                errors = errors + 1;
            end
            rp32 = ~rp32;
            #1;
            if (e32 !== 1'b1) begin
                $display("[ERROR] W32 flipped parity missed d=%h", d32);
                errors = errors + 1;
            end
        end

        if (errors == 0) $display("[PASS] parity exhaustive/random/decoupled/parameterized");
        else begin $display("[FAIL] parity: %0d error(s)", errors); $fatal(1); end
        $finish;
    end
endmodule
