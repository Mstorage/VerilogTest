`timescale 1ns/1ps
// 测试契约：gray = bin ^ (bin>>1)；bin_out 为格雷码解码；相邻格雷码汉明距离为 1。
// 覆盖：
//   1. WIDTH=8 穷举（256 组）双向转换 + 相邻性（含 255->0 回绕相邻）；
//   2. 独立解码向量（防止编码和解码共用同一个错误时互相抵消）；
//   3. WIDTH=5 穷举实例（含相邻性与回绕）、WIDTH=32 随机+边界实例，验证位宽参数化；
//   4. 校验器自检：编码后再解码必须还原。
module tb_09_binary_gray_converter;
    localparam integer WIDTH = 8;
    reg  [WIDTH-1:0] bin, gray_in;
    wire [WIDTH-1:0] gray, bin_out;
    reg  [WIDTH-1:0] expected_gray, expected_bin, previous_gray;
    reg  [31:0] f32;
    integer errors, value, changed_bits, i, seed;

    binary_gray_converter #(.WIDTH(WIDTH)) dut (
        .bin(bin), .gray_in(gray_in), .gray(gray), .bin_out(bin_out)
    );

    // WIDTH=5 穷举实例。
    reg [4:0] bin5, gray5_in, prev_gray5;
    wire [4:0] gray5, bin5_out;
    binary_gray_converter #(.WIDTH(5)) dut5 (
        .bin(bin5), .gray_in(gray5_in), .gray(gray5), .bin_out(bin5_out)
    );

    // WIDTH=32 随机实例。
    reg [31:0] bin32, gray32_in;
    wire [31:0] gray32, bin32_out;
    binary_gray_converter #(.WIDTH(32)) dut32 (
        .bin(bin32), .gray_in(gray32_in), .gray(gray32), .bin_out(bin32_out)
    );

    // 位宽无关的转换函数（以 32 位为上限，超出部分为 0，直接截位使用）。
    function [31:0] f_bin2gray;
        input [31:0] b;
        begin
            f_bin2gray = b ^ (b >> 1);
        end
    endfunction

    function [31:0] f_gray2bin;
        input [31:0] g;
        integer k;
        begin
            f_gray2bin[31] = g[31];
            for (k = 30; k >= 0; k = k - 1)
                f_gray2bin[k] = f_gray2bin[k+1] ^ g[k];
        end
    endfunction

    // 返回两个 32 位值之间不同位的个数。
    function integer popcount_diff;
        input [31:0] a, b;
        integer k, cnt;
        begin
            cnt = 0;
            for (k = 0; k < 32; k = k + 1)
                if (a[k] !== b[k]) cnt = cnt + 1;
            popcount_diff = cnt;
        end
    endfunction

    initial begin
        errors = 0; seed = 32'h9A6E_0009;
        bin = 0; gray_in = 0; previous_gray = 0;

        // WIDTH=8 穷举。
        for (value = 0; value < 256; value = value + 1) begin
            bin = value[7:0];
            f32 = f_bin2gray({24'b0, bin});
            expected_gray = f32[7:0];
            gray_in = expected_gray;
            f32 = f_gray2bin({24'b0, expected_gray});
            expected_bin = f32[7:0];
            #1;
            if (gray !== expected_gray) begin
                $display("[ERROR] bin=%h exp gray=%h act=%h", bin, expected_gray, gray);
                errors = errors + 1;
            end
            if (bin_out !== expected_bin || bin_out !== bin) begin
                $display("[ERROR] gray=%h exp bin=%h act=%h", gray_in, expected_bin, bin_out);
                errors = errors + 1;
            end
            if (value > 0) begin
                changed_bits = popcount_diff({24'b0, gray}, {24'b0, previous_gray});
                if (changed_bits != 1) begin
                    $display("[ERROR] adjacent values changed %0d gray bits at bin=%0d", changed_bits, value);
                    errors = errors + 1;
                end
            end
            previous_gray = gray;
        end

        // 回绕相邻性：255 -> 0 的格雷码也必须只差 1 位。
        changed_bits = popcount_diff({24'b0, previous_gray}, 32'h0);
        if (changed_bits != 1) begin
            $display("[ERROR] wrap-around gray adjacency changed %0d bits", changed_bits);
            errors = errors + 1;
        end

        // 独立解码向量，避免编码和解码用同一个错误时互相抵消。
        gray_in = 8'b1101_0100; #1;
        f32 = f_gray2bin({24'b0, 8'b1101_0100});
        if (bin_out !== f32[7:0]) begin
            $display("[ERROR] independent gray decode vector"); errors = errors + 1;
        end

        // WIDTH=5 穷举（含相邻性与回绕）。
        bin5 = 0; gray5_in = 0; prev_gray5 = 0;
        for (value = 0; value < 32; value = value + 1) begin
            bin5 = value[4:0];
            f32 = f_bin2gray({27'b0, bin5});
            expected_gray = f32[7:0];
            gray5_in = expected_gray[4:0];
            f32 = f_gray2bin({27'b0, gray5_in});
            expected_bin = f32[7:0];
            #1;
            if (gray5 !== expected_gray[4:0]) begin
                $display("[ERROR] W5 bin=%h exp gray=%h act=%h", bin5, expected_gray[4:0], gray5);
                errors = errors + 1;
            end
            if (bin5_out !== expected_bin[4:0]) begin
                $display("[ERROR] W5 gray=%h exp bin=%h act=%h", gray5_in, expected_bin[4:0], bin5_out);
                errors = errors + 1;
            end
            if (value > 0) begin
                changed_bits = popcount_diff({27'b0, gray5}, {27'b0, prev_gray5});
                if (changed_bits != 1) begin
                    $display("[ERROR] W5 adjacent changed %0d bits at bin=%0d", changed_bits, value);
                    errors = errors + 1;
                end
            end
            prev_gray5 = gray5;
        end
        changed_bits = popcount_diff({27'b0, prev_gray5}, 32'h0);
        if (changed_bits != 1) begin
            $display("[ERROR] W5 wrap-around adjacency changed %0d bits", changed_bits);
            errors = errors + 1;
        end

        // WIDTH=32 随机 + 边界。
        for (i = 0; i < 100; i = i + 1) begin
            bin32 = $random(seed);
            gray32_in = f_bin2gray(bin32);
            #1;
            if (gray32 !== f_bin2gray(bin32)) begin
                $display("[ERROR] W32 bin=%h exp gray=%h act=%h", bin32, f_bin2gray(bin32), gray32);
                errors = errors + 1;
            end
            if (bin32_out !== f_gray2bin(gray32_in)) begin
                $display("[ERROR] W32 gray=%h exp bin=%h act=%h", gray32_in, f_gray2bin(gray32_in), bin32_out);
                errors = errors + 1;
            end
            if (bin32_out !== bin32) begin
                $display("[ERROR] W32 round-trip mismatch bin=%h out=%h", bin32, bin32_out);
                errors = errors + 1;
            end
        end
        bin32 = 32'hFFFF_FFFF; gray32_in = 32'h0; #1;
        if (gray32 !== 32'h8000_0000) begin
            $display("[ERROR] W32 all-ones gray=%h", gray32); errors = errors + 1;
        end
        gray32_in = 32'h8000_0000; #1;
        if (bin32_out !== 32'hFFFF_FFFF) begin
            $display("[ERROR] W32 all-ones decode=%h", bin32_out); errors = errors + 1;
        end

        // 校验器自检：编码后再解码应还原。
        for (i = 0; i < 20; i = i + 1) begin
            bin32 = $random(seed);
            if (f_gray2bin(f_bin2gray(bin32)) !== bin32) begin
                $display("[ERROR] checker self-check failed at %h", bin32);
                errors = errors + 1;
            end
        end

        if (errors == 0) $display("[PASS] exhaustive binary/Gray conversion + W5/W32 parameterization");
        else begin $display("[FAIL] binary_gray_converter: %0d error(s)", errors); $fatal(1); end
        $finish;
    end
endmodule
