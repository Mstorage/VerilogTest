`timescale 1ns/1ps
// ============================================================================
// 题目：优先编码器与独热编码器
// 难度：★☆☆☆☆☆
// 编号：01_basic_rtl/02_priority_onehot_encoder
//
// 要求：实现参数化编码器，同时输出 `valid`；req[N-1] 优先级最高，onehot 仅保留获胜位。
//
// 建议参数：N=8、INDEX_WIDTH=3
// 端口列表（方向 / 位宽 / 名称）：
//   - input  N                req
//   - output INDEX_WIDTH      code
//   - output 1                valid
//   - output N                onehot
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=01_basic_rtl/02_priority_onehot_encoder；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module priority_onehot_encoder #(
    parameter integer N = 8,
    parameter integer INDEX_WIDTH = 3
) (
    input wire [N-1:0] req,
    output reg [INDEX_WIDTH-1:0] code,
    output reg valid,
    output reg [N-1:0] onehot
);

integer i;

always@(*)begin
    valid = 0;
    code = {INDEX_WIDTH{1'b0}};
    onehot = {N{1'b0}};

    for (i = N-1;i >= 0 ;i=i-1 ) begin
        if(req[i] == 1 && !valid)begin
            onehot[i] = 1'b1;
            code = i[INDEX_WIDTH-1:0];
            valid = 1'b1;
        end
    end
end

endmodule
