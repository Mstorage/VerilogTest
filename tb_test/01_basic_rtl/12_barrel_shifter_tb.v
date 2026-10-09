`timescale 1ns/1ps
// 测试契约：dir=0 左移、dir=1 右移；arithmetic_shift 仅影响右移的符号扩展；
// 移位量 >= WIDTH 时左移/逻辑右移得 0，算术右移得全符号位。
// 覆盖：
//   1. WIDTH=8 全空间穷举：256 din × 16 shamt × 2 方向 × 2 算术模式（16384 组合）；
//   2. arith 不得影响左移（穷举中逐组合核对）；正数/负数算术右移边界；
//   3. WIDTH=32/SHIFT_WIDTH=5 实例：31 位移位、0 位移位恒等等定向边界 + 随机 150 组
//      （shamt 含 >= 32 的情况）。
module tb_12_barrel_shifter;
    localparam integer WIDTH = 8;
    localparam integer SHIFT_WIDTH = 4; // 能表达 >= WIDTH 的移位量
    reg [WIDTH-1:0] din;
    reg [SHIFT_WIDTH-1:0] shamt;
    reg dir, arithmetic_shift;
    wire [WIDTH-1:0] dout;
    reg [WIDTH-1:0] expected;
    reg signed [WIDTH-1:0] signed_data;
    integer errors, amount, value, i, seed;

    barrel_shifter #(.WIDTH(WIDTH), .SHIFT_WIDTH(SHIFT_WIDTH)) dut (
        .din(din), .shamt(shamt), .dir(dir),
        .arithmetic_shift(arithmetic_shift), .dout(dout)
    );

    // WIDTH=32 / SHIFT_WIDTH=5 参数化实例。
    reg [31:0] d32;
    reg [4:0] s32;
    reg dir32, ar32;
    wire [31:0] o32;
    reg [31:0] e32;
    reg signed [31:0] sd32;
    barrel_shifter #(.WIDTH(32), .SHIFT_WIDTH(5)) dut32 (
        .din(d32), .shamt(s32), .dir(dir32),
        .arithmetic_shift(ar32), .dout(o32)
    );

    task check_shift;
        input [WIDTH-1:0] value;
        input [SHIFT_WIDTH-1:0] shift_value;
        input direction;
        input arithmetic_mode;
        input [WIDTH-1:0] expected_value;
        begin
            din = value; shamt = shift_value; dir = direction;
            arithmetic_shift = arithmetic_mode; expected = expected_value;
            #1;
            if (dout !== expected) begin
                $display("[ERROR] din=%b shamt=%0d dir=%b arith=%b expected=%b actual=%b",
                         value, shift_value, direction, arithmetic_mode, expected, dout);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0; seed = 32'hBA5E_0012;

        // WIDTH=8 全空间穷举。
        for (value = 0; value < 256; value = value + 1) begin
            for (amount = 0; amount < 16; amount = amount + 1) begin
                din = value[7:0]; shamt = amount[3:0];
                // 左移：arith 不得影响结果（两种模式同一期望）。
                dir = 1'b0; arithmetic_shift = 1'b0;
                expected = din << shamt; #1;
                if (dout !== expected) begin
                    $display("[ERROR] L din=%b shamt=%0d exp=%b act=%b", din, shamt, expected, dout);
                    errors = errors + 1;
                end
                arithmetic_shift = 1'b1; #1;
                if (dout !== expected) begin
                    $display("[ERROR] arith affected left shift din=%b shamt=%0d", din, shamt);
                    errors = errors + 1;
                end
                // 逻辑右移。
                dir = 1'b1; arithmetic_shift = 1'b0;
                expected = din >> shamt; #1;
                if (dout !== expected) begin
                    $display("[ERROR] RL din=%b shamt=%0d exp=%b act=%b", din, shamt, expected, dout);
                    errors = errors + 1;
                end
                // 算术右移。
                arithmetic_shift = 1'b1;
                signed_data = din;
                expected = signed_data >>> shamt; #1;
                if (dout !== expected) begin
                    $display("[ERROR] RA din=%b shamt=%0d exp=%b act=%b", din, shamt, expected, dout);
                    errors = errors + 1;
                end
            end
        end

        // 定向：arith 不错误影响左移、符号扩展边界、shamt=0 恒等。
        check_shift(8'h81, 4'd3, 0, 1, 8'h08);
        check_shift(8'h80, 4'd7, 1, 1, 8'hFF);
        check_shift(8'h7F, 4'd7, 1, 1, 8'h00);
        check_shift(8'h80, 4'd0, 1, 1, 8'h80);
        check_shift(8'h01, 4'd15, 0, 0, 8'h00);

        // WIDTH=32 实例定向边界。
        d32 = 32'h0000_0001; s32 = 5'd31; dir32 = 0; ar32 = 0; #1;
        if (o32 !== 32'h8000_0000) begin
            $display("[ERROR] W32 left 31 exp=80000000 act=%h", o32); errors = errors + 1;
        end
        d32 = 32'h8000_0000; s32 = 5'd31; dir32 = 1; ar32 = 0; #1;
        if (o32 !== 32'h0000_0001) begin
            $display("[ERROR] W32 logical right 31 act=%h", o32); errors = errors + 1;
        end
        ar32 = 1; #1;
        if (o32 !== 32'hFFFF_FFFF) begin
            $display("[ERROR] W32 arithmetic right 31 act=%h", o32); errors = errors + 1;
        end
        d32 = 32'h0000_FFFF; s32 = 5'd16; dir32 = 0; ar32 = 1; #1;
        if (o32 !== 32'hFFFF_0000) begin
            $display("[ERROR] W32 left 16 arith=1 act=%h", o32); errors = errors + 1;
        end
        d32 = 32'h8000_0000; s32 = 5'd0; dir32 = 1; ar32 = 1; #1;
        if (o32 !== 32'h8000_0000) begin
            $display("[ERROR] W32 shamt=0 identity act=%h", o32); errors = errors + 1;
        end

        // WIDTH=32 随机 150 组（shamt 含 >= 32 的情况）。
        for (i = 0; i < 150; i = i + 1) begin
            d32 = $random(seed);
            s32 = $random(seed) & 5'b11111;
            dir32 = $random(seed) & 1'b1;
            ar32  = $random(seed) & 1'b1;
            // 注意：不能用三目混合有符号/无符号分支，否则 >>> 会退化为 >>。
            if (dir32 == 0) e32 = d32 << s32;
            else begin
                if (ar32) begin sd32 = d32; e32 = sd32 >>> s32; end
                else e32 = d32 >> s32;
            end
            #1;
            if (o32 !== e32) begin
                $display("[ERROR] W32 random d=%h s=%0d dir=%b ar=%b exp=%h act=%h",
                         d32, s32, dir32, ar32, e32, o32);
                errors = errors + 1;
            end
        end

        if (errors == 0) $display("[PASS] barrel shift exhaustive/random/parameterized");
        else begin $display("[FAIL] barrel_shifter: %0d error(s)", errors); $fatal(1); end
        $finish;
    end
endmodule
