`timescale 1ns/1ps
// ============================================================================
// 题目：可配置移位寄存器
// 难度：★★☆☆☆☆
// 编号：01_basic_rtl/07_shift_register
//
// 要求：支持左移、右移、并行装载和保持；dir=0 左移、dir=1 右移，优先级 reset > load > en。
//
// 建议参数：WIDTH=8
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                load
//   - input  1                dir
//   - input  1                en
//   - input  WIDTH            pdata
//   - input  1                serial_in
//   - output WIDTH            q
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=01_basic_rtl/07_shift_register；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module shift_register #(
    parameter integer WIDTH = 8
) (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire dir,
    input wire en,
    input wire [WIDTH-1:0] pdata,
    input wire serial_in,
    output reg [WIDTH-1:0] q
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
