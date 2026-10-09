`timescale 1ns/1ps
// ============================================================================
// 题目：计数器族
// 难度：★★☆☆☆☆
// 编号：01_basic_rtl/08_counter_family
//
// 要求：mode=00 自然回卷、01 模 MODULO、10 饱和、11 保持；up 控制加减，并正确输出边界脉冲。
//
// 建议参数：WIDTH=8、MODULO=100
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                en
//   - input  1                up
//   - input  2                mode
//   - output WIDTH            q
//   - output 1                wrap
//   - output 1                saturated
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=01_basic_rtl/08_counter_family；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module counter_family #(
    parameter integer WIDTH = 8,
    parameter integer MODULO = 100
) (
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire up,
    input wire [2-1:0] mode,
    output reg [WIDTH-1:0] q,
    output reg wrap,
    output reg saturated
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
