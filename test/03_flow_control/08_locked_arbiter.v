`timescale 1ns/1ps
// ============================================================================
// 题目：锁定式仲裁器
// 难度：★★★★☆☆
// 编号：03_flow_control/08_locked_arbiter
//
// 要求：一旦选中就保持授权至事务结束，同时处理结束与新请求同周期到达。
//
// 建议参数：N=4
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  N                req
//   - input  1                transaction_done
//   - output N                grant
//   - output 1                grant_valid
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=03_flow_control/08_locked_arbiter；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module locked_arbiter #(
    parameter integer N = 4
) (
    input wire clk,
    input wire rst_n,
    input wire [N-1:0] req,
    input wire transaction_done,
    output reg [N-1:0] grant,
    output reg grant_valid
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
