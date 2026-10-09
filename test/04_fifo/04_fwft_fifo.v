`timescale 1ns/1ps
// ============================================================================
// 题目：First-Word Fall-Through FIFO
// 难度：★★★☆☆☆
// 编号：04_fifo/04_fwft_fifo
//
// 要求：非空时首字自动出现在输出端，并维持 Ready/Valid 语义。
//
// 建议参数：WIDTH=8、DEPTH=16、ADDR_WIDTH=4
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
//   3. 执行 make run Q=04_fifo/04_fwft_fifo；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module fwft_fifo #(
    parameter integer WIDTH = 8,
    parameter integer DEPTH = 16,
    parameter integer ADDR_WIDTH = 4
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
