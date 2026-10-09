`timescale 1ns/1ps
// ============================================================================
// 题目：参数化桶形移位器
// 难度：★★★☆☆☆
// 编号：01_basic_rtl/12_barrel_shifter
//
// 要求：dir=0 左移、dir=1 右移；arithmetic_shift 仅控制右移符号扩展，并处理移位量 >= WIDTH。
//
// 建议参数：WIDTH=32、SHIFT_WIDTH=5
// 端口列表（方向 / 位宽 / 名称）：
//   - input  WIDTH            din
//   - input  SHIFT_WIDTH      shamt
//   - input  1                dir
//   - input  1                arithmetic_shift
//   - output WIDTH            dout
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=01_basic_rtl/12_barrel_shifter；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module barrel_shifter #(
    parameter integer WIDTH = 32,
    parameter integer SHIFT_WIDTH = 5
) (
    input wire [WIDTH-1:0] din,
    input wire [SHIFT_WIDTH-1:0] shamt,
    input wire dir,
    input wire arithmetic_shift,
    output reg [WIDTH-1:0] dout
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
