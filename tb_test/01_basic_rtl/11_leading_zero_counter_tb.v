`timescale 1ns/1ps
// 测试契约：din=0 时 valid=0、count=WIDTH；否则 count 为最高置位之前的 0 个数。
// 覆盖：
//   1. WIDTH=32 定向向量（全 one-hot 逐位、混合边界、随机 200 组）；
//   2. valid 与 count 的一致性检查（valid == count != WIDTH）；
//   3. WIDTH=8/COUNT_WIDTH=4 穷举实例、WIDTH=1/COUNT_WIDTH=1 边界实例，验证参数化。
module tb_11_leading_zero_counter;
    localparam integer WIDTH = 32;
    localparam integer COUNT_WIDTH = 6;
    reg  [WIDTH-1:0] din;
    wire [COUNT_WIDTH-1:0] count;
    wire valid;
    integer errors, bit_position, expected_count, i, seed;

    leading_zero_counter #(.WIDTH(WIDTH), .COUNT_WIDTH(COUNT_WIDTH)) dut (
        .din(din), .count(count), .valid(valid)
    );

    // WIDTH=8 穷举实例。
    reg [7:0] din8;
    wire [3:0] count8;
    wire valid8;
    leading_zero_counter #(.WIDTH(8), .COUNT_WIDTH(4)) dut8 (
        .din(din8), .count(count8), .valid(valid8)
    );

    // WIDTH=1 边界实例。
    reg din1;
    wire [0:0] count1;
    wire valid1;
    leading_zero_counter #(.WIDTH(1), .COUNT_WIDTH(1)) dut1 (
        .din(din1), .count(count1), .valid(valid1)
    );

    // 位宽无关的期望值：最高置位为 k 时 count = bits-1-k；无置位时 count = bits。
    function integer lzc_expected;
        input [31:0] v;
        input integer bits;
        integer k;
        begin
            lzc_expected = bits;
            for (k = bits - 1; k >= 0; k = k - 1) begin
                if (v[k]) begin
                    lzc_expected = bits - 1 - k;
                    k = -1;
                end
            end
        end
    endfunction

    task check_value;
        input [WIDTH-1:0] value;
        input integer expected;
        input expected_valid;
        begin
            din = value; #1;
            if (count !== expected[COUNT_WIDTH-1:0] || valid !== expected_valid) begin
                $display("[ERROR] din=%h expected count/valid=%0d/%b actual=%0d/%b",
                         value, expected, expected_valid, count, valid);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0; seed = 32'h12C0_0011;

        check_value(32'h0000_0000, 32, 0);
        // 每一个 one-hot 位置都测试，可发现方向反了和 off-by-one。
        for (bit_position = 0; bit_position < WIDTH; bit_position = bit_position + 1) begin
            expected_count = WIDTH - 1 - bit_position;
            check_value(32'b1 << bit_position, expected_count, 1);
        end
        check_value(32'h8000_0001, 0, 1);
        check_value(32'h00F0_0000, 8, 1);
        check_value(32'h0000_00A5, 24, 1);
        check_value(32'h0001_0000, 15, 1);
        check_value(32'hFFFF_FFFF, 0, 1);
        check_value(32'h7FFF_FFFF, 1, 1);

        // 随机 200 组，含最高位随机分布。
        for (i = 0; i < 200; i = i + 1) begin
            din = $random(seed);
            expected_count = lzc_expected(din, WIDTH);
            #1;
            if (count !== expected_count[COUNT_WIDTH-1:0] || valid !== (din != 0)) begin
                $display("[ERROR] random din=%h exp=%0d act=%0d valid=%b", din, expected_count, count, valid);
                errors = errors + 1;
            end
            if (valid !== (count != WIDTH)) begin
                $display("[ERROR] valid/count inconsistent: din=%h count=%0d valid=%b", din, count, valid);
                errors = errors + 1;
            end
        end

        // WIDTH=8 穷举。
        for (i = 0; i < 256; i = i + 1) begin
            din8 = i[7:0];
            expected_count = lzc_expected({24'b0, din8}, 8);
            #1;
            if (count8 !== expected_count[3:0] || valid8 !== (i != 0)) begin
                $display("[ERROR] W8 din=%h exp=%0d act=%0d valid=%b", din8, expected_count, count8, valid8);
                errors = errors + 1;
            end
        end

        // WIDTH=1 边界。
        din1 = 1'b0; #1;
        if (count1 !== 1'b1 || valid1 !== 1'b0) begin
            $display("[ERROR] W1 zero count/valid=%b/%b", count1, valid1);
            errors = errors + 1;
        end
        din1 = 1'b1; #1;
        if (count1 !== 1'b0 || valid1 !== 1'b1) begin
            $display("[ERROR] W1 one count/valid=%b/%b", count1, valid1);
            errors = errors + 1;
        end

        if (errors == 0) $display("[PASS] leading-zero count direction/zero/off-by-one, random + parameterized");
        else begin $display("[FAIL] leading_zero_counter: %0d error(s)", errors); $fatal(1); end
        $finish;
    end
endmodule
