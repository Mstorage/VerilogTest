`timescale 1ns/1ps
// 测试契约：req[N-1] 优先级最高；valid=1 时 onehot 仅保留获胜位、code 为该位索引；
// 无请求时 valid=0、onehot=0（code 不作约束）。
// 覆盖：
//   1. N=8 全部 256 种请求向量穷举（优先级、code、onehot 唯一性、valid 一致性）；
//   2. N=3/INDEX_WIDTH=2 第二个实例穷举 8 种向量，验证参数化；
//   3. 多请求同时有效的边界（最低位单点、交错位、全 1）被穷举自然覆盖。
module tb_02_priority_onehot_encoder;
    localparam integer N = 8;
    localparam integer INDEX_WIDTH = 3;
    reg  [N-1:0] req;
    wire [INDEX_WIDTH-1:0] code;
    wire valid;
    wire [N-1:0] onehot;
    integer errors, i, k, hi, ones;
    reg [N-1:0] exp_onehot;

    priority_onehot_encoder #(.N(N), .INDEX_WIDTH(INDEX_WIDTH)) dut (
        .req(req), .code(code), .valid(valid), .onehot(onehot)
    );

    // N=3 参数化实例。
    reg  [2:0] req3;
    wire [1:0] code3;
    wire valid3;
    wire [2:0] onehot3;
    priority_onehot_encoder #(.N(3), .INDEX_WIDTH(2)) dut3 (
        .req(req3), .code(code3), .valid(valid3), .onehot(onehot3)
    );

    // 返回 32 位向量中最高置位的索引（输入为 0 时返回 0，仅 valid 时使用）。
    function integer highest_bit;
        input [31:0] v;
        integer k;
        begin
            highest_bit = 0;
            for (k = 0; k < 32; k = k + 1)
                if (v[k]) highest_bit = k;
        end
    endfunction

    initial begin
        errors = 0;

        // N=8 穷举。
        for (i = 0; i < 256; i = i + 1) begin
            req = i[7:0];
            #1;
            hi = highest_bit({24'b0, req});
            exp_onehot = (i == 0) ? {N{1'b0}} : (1'b1 << hi);
            if (valid !== (i != 0)) begin
                $display("[ERROR] req=%b valid=%b", req, valid);
                errors = errors + 1;
            end
            if (onehot !== exp_onehot) begin
                $display("[ERROR] req=%b exp onehot=%b act=%b", req, exp_onehot, onehot);
                errors = errors + 1;
            end
            if (i != 0 && code !== hi[INDEX_WIDTH-1:0]) begin
                $display("[ERROR] req=%b exp code=%0d act=%0d", req, hi, code);
                errors = errors + 1;
            end
            // onehot 唯一性：valid 时恰好一位为 1，否则全 0。
            ones = 0;
            for (k = 0; k < N; k = k + 1)
                if (onehot[k]) ones = ones + 1;
            if ((i != 0 && ones != 1) || (i == 0 && ones != 0)) begin
                $display("[ERROR] req=%b onehot popcount=%0d", req, ones);
                errors = errors + 1;
            end
        end

        // N=3 穷举。
        for (i = 0; i < 8; i = i + 1) begin
            req3 = i[2:0];
            #1;
            hi = highest_bit({29'b0, req3});
            if (valid3 !== (i != 0)) begin
                $display("[ERROR] N3 req=%b valid=%b", req3, valid3);
                errors = errors + 1;
            end
            if (onehot3 !== (i == 0 ? 3'b000 : (3'b1 << hi))) begin
                $display("[ERROR] N3 req=%b exp onehot=%b act=%b",
                         req3, (i == 0 ? 3'b000 : (3'b1 << hi)), onehot3);
                errors = errors + 1;
            end
            if (i != 0 && code3 !== hi[1:0]) begin
                $display("[ERROR] N3 req=%b exp code=%0d act=%0d", req3, hi, code3);
                errors = errors + 1;
            end
        end

        if (errors == 0) $display("[PASS] encoder priority/valid/onehot exhaustive + N=3 parameterization");
        else begin $display("[FAIL] encoder: %0d error(s)", errors); $fatal(1); end
        $finish;
    end
endmodule
