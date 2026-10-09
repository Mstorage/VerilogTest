`timescale 1ns/1ps
// ============================================================================
// 题目：固定优先级仲裁器
// 难度：★★★☆☆☆
// 编号：03_flow_control/05_fixed_priority_arbiter
//
// 要求：N 个请求选一个授权；定义无请求、多请求和请求撤销时的行为。
//
// 建议参数：N=4
// 端口列表（方向 / 位宽 / 名称）：
//   - input  N                req
//   - output N                grant
//   - output 1                grant_valid
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=03_flow_control/05_fixed_priority_arbiter；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module fixed_priority_arbiter #(
    parameter integer N = 4
) (
    input wire [N-1:0] req,
    output reg [N-1:0] grant,
    output reg grant_valid
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
