`timescale 1ns/1ps
// ============================================================================
// 题目：Latch 的实现与规避
// 难度：★☆☆☆☆☆
// 编号：01_basic_rtl/05_latch
//
// 要求：先实现门控 D latch，再修复一个因组合分支赋值不完整而意外推断的 latch。
//
// 建议参数：WIDTH=8
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                gate
//   - input  WIDTH            d
//   - output WIDTH            q
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=01_basic_rtl/05_latch；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module gated_latch #(
    parameter integer WIDTH = 8
) (
    input wire gate,
    input wire [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    always @(*) begin
        if(gate) begin
            q = d;
        end
    end// TODO_IMPLEMENT: 在此完成设计。

endmodule
