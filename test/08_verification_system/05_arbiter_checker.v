`timescale 1ns/1ps
// ============================================================================
// 题目：仲裁器公平性验证
// 难度：★★★★☆☆
// 编号：08_verification_system/05_arbiter_checker
//
// 要求：检查 one-hot grant、无请求不授权，以及持续请求在有限周期内获服务。
//
// 建议参数：N=4、MAX_WAIT=16
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  N                req
//   - input  N                grant
//   - input  1                accept
//   - output 1                error
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=08_verification_system/05_arbiter_checker；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module arbiter_checker #(
    parameter integer N = 4,
    parameter integer MAX_WAIT = 16
) (
    input wire clk,
    input wire rst_n,
    input wire [N-1:0] req,
    input wire [N-1:0] grant,
    input wire accept,
    output reg error
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
