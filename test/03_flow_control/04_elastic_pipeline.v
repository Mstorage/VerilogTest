`timescale 1ns/1ps
// ============================================================================
// 题目：两级弹性流水线
// 难度：★★★☆☆☆
// 编号：03_flow_control/04_elastic_pipeline
//
// 要求：支持满吞吐连续传输和任意背压，分析延迟、容量与组合路径。
//
// 建议参数：WIDTH=8、STAGES=2
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                s_valid
//   - output 1                s_ready
//   - input  WIDTH            s_data
//   - output 1                m_valid
//   - input  1                m_ready
//   - output WIDTH            m_data
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=03_flow_control/04_elastic_pipeline；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module elastic_pipeline #(
    parameter integer WIDTH = 8,
    parameter integer STAGES = 2
) (
    input wire clk,
    input wire rst_n,
    input wire s_valid,
    output reg s_ready,
    input wire [WIDTH-1:0] s_data,
    output reg m_valid,
    input wire m_ready,
    output reg [WIDTH-1:0] m_data
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
