`timescale 1ns/1ps
// ============================================================================
// 题目：请求-应答四相握手
// 难度：★★☆☆☆☆
// 编号：03_flow_control/01_four_phase_handshake
//
// 要求：源端保持数据直至应答，目的端只接收一次，并处理连续请求。
//
// 建议参数：WIDTH=8
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                src_clk
//   - input  1                dst_clk
//   - input  1                rst_n
//   - input  1                send
//   - input  WIDTH            data_in
//   - output 1                busy
//   - output 1                data_valid
//   - output WIDTH            data_out
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=03_flow_control/01_four_phase_handshake；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module four_phase_handshake #(
    parameter integer WIDTH = 8
) (
    input wire src_clk,
    input wire dst_clk,
    input wire rst_n,
    input wire send,
    input wire [WIDTH-1:0] data_in,
    output reg busy,
    output reg data_valid,
    output reg [WIDTH-1:0] data_out
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
