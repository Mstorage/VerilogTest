`timescale 1ns/1ps
// ============================================================================
// 题目：加权轮询仲裁器
// 难度：★★★★☆☆
// 编号：03_flow_control/07_weighted_round_robin
//
// 要求：为各请求端配置权重，在持续竞争下按配额服务并正确跨轮次恢复。
//
// 建议参数：N=4、WEIGHT_WIDTH=4
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  N                req
//   - input  N*WEIGHT_WIDTH   weights
//   - input  1                accept
//   - output N                grant
//   - output 1                grant_valid
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=03_flow_control/07_weighted_round_robin；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module weighted_round_robin #(
    parameter integer N = 4,
    parameter integer WEIGHT_WIDTH = 4
) (
    input wire clk,
    input wire rst_n,
    input wire [N-1:0] req,
    input wire [N*WEIGHT_WIDTH-1:0] weights,
    input wire accept,
    output reg [N-1:0] grant,
    output reg grant_valid
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
