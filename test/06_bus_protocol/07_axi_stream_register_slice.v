`timescale 1ns/1ps
// ============================================================================
// 题目：AXI4-Stream 寄存切片
// 难度：★★★★☆☆
// 编号：06_bus_protocol/07_axi_stream_register_slice
//
// 要求：支持 `TVALID/TREADY/TDATA/TLAST`，在连续流和随机背压下无丢失。
//
// 建议参数：DATA_WIDTH=32
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                aclk
//   - input  1                areset_n
//   - input  1                s_tvalid
//   - output 1                s_tready
//   - input  DATA_WIDTH       s_tdata
//   - input  1                s_tlast
//   - output 1                m_tvalid
//   - input  1                m_tready
//   - output DATA_WIDTH       m_tdata
//   - output 1                m_tlast
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=06_bus_protocol/07_axi_stream_register_slice；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module axi_stream_register_slice #(
    parameter integer DATA_WIDTH = 32
) (
    input wire aclk,
    input wire areset_n,
    input wire s_tvalid,
    output reg s_tready,
    input wire [DATA_WIDTH-1:0] s_tdata,
    input wire s_tlast,
    output reg m_tvalid,
    input wire m_tready,
    output reg [DATA_WIDTH-1:0] m_tdata,
    output reg m_tlast
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
