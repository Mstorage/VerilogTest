`timescale 1ns/1ps
// ============================================================================
// 题目：自检式计数器 testbench
// 难度：★★☆☆☆☆
// 编号：08_verification_system/01_counter_checker
//
// 要求：自动产生激励和参考值，覆盖复位、使能、回卷并给出 PASS/FAIL。
//
// 建议参数：WIDTH=8、MODULO=100
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                en
//   - input  WIDTH            observed_count
//   - output 1                error
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=08_verification_system/01_counter_checker；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module counter_checker #(
    parameter integer WIDTH = 8,
    parameter integer MODULO = 100
) (
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire [WIDTH-1:0] observed_count,
    output reg error
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
