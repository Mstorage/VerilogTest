`timescale 1ns/1ps
// ============================================================================
// 题目：D 触发器与带使能寄存器
// 难度：★☆☆☆☆☆
// 编号：01_basic_rtl/04_dff_enable
//
// 要求：实现低有效异步复位、上升沿采样的带使能寄存器；优先级为 reset > enable > hold。
//
// 建议参数：WIDTH=8
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                en
//   - input  WIDTH            d
//   - output WIDTH            q
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=01_basic_rtl/04_dff_enable；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module dff_enable #(
    parameter integer WIDTH = 8
) (
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
