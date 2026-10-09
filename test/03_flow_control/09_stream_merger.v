`timescale 1ns/1ps
// ============================================================================
// 题目：多入口到单出口流合并器
// 难度：★★★★☆☆
// 编号：03_flow_control/09_stream_merger
//
// 要求：将仲裁与 Ready/Valid 组合，要求背压时选择结果和输出数据稳定。
//
// 建议参数：N=4、WIDTH=8
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  N                s_valid
//   - output N                s_ready
//   - input  N*WIDTH          s_data
//   - output 1                m_valid
//   - input  1                m_ready
//   - output WIDTH            m_data
//   - output N                selected
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=03_flow_control/09_stream_merger；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module stream_merger #(
    parameter integer N = 4,
    parameter integer WIDTH = 8
) (
    input wire clk,
    input wire rst_n,
    input wire [N-1:0] s_valid,
    output reg [N-1:0] s_ready,
    input wire [N*WIDTH-1:0] s_data,
    output reg m_valid,
    input wire m_ready,
    output reg [WIDTH-1:0] m_data,
    output reg [N-1:0] selected
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
