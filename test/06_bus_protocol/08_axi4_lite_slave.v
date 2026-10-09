`timescale 1ns/1ps
// ============================================================================
// 题目：AXI4-Lite 从设备
// 难度：★★★★☆☆
// 编号：06_bus_protocol/08_axi4_lite_slave
//
// 要求：独立处理 AW/W/B 与 AR/R 通道，支持字节写使能和响应保持。
//
// 建议参数：ADDR_WIDTH=12、DATA_WIDTH=32
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                aclk
//   - input  1                areset_n
//   - input  ADDR_WIDTH       s_awaddr
//   - input  1                s_awvalid
//   - output 1                s_awready
//   - input  DATA_WIDTH       s_wdata
//   - input  DATA_WIDTH/8     s_wstrb
//   - input  1                s_wvalid
//   - output 1                s_wready
//   - output 2                s_bresp
//   - output 1                s_bvalid
//   - input  1                s_bready
//   - input  ADDR_WIDTH       s_araddr
//   - input  1                s_arvalid
//   - output 1                s_arready
//   - output DATA_WIDTH       s_rdata
//   - output 2                s_rresp
//   - output 1                s_rvalid
//   - input  1                s_rready
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=06_bus_protocol/08_axi4_lite_slave；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module axi4_lite_slave #(
    parameter integer ADDR_WIDTH = 12,
    parameter integer DATA_WIDTH = 32
) (
    input wire aclk,
    input wire areset_n,
    input wire [ADDR_WIDTH-1:0] s_awaddr,
    input wire s_awvalid,
    output reg s_awready,
    input wire [DATA_WIDTH-1:0] s_wdata,
    input wire [DATA_WIDTH/8-1:0] s_wstrb,
    input wire s_wvalid,
    output reg s_wready,
    output reg [2-1:0] s_bresp,
    output reg s_bvalid,
    input wire s_bready,
    input wire [ADDR_WIDTH-1:0] s_araddr,
    input wire s_arvalid,
    output reg s_arready,
    output reg [DATA_WIDTH-1:0] s_rdata,
    output reg [2-1:0] s_rresp,
    output reg s_rvalid,
    input wire s_rready
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
