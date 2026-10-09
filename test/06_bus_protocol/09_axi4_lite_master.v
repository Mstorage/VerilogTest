`timescale 1ns/1ps
// ============================================================================
// 题目：AXI4-Lite 主设备
// 难度：★★★★★☆
// 编号：06_bus_protocol/09_axi4_lite_master
//
// 要求：将本地读写请求转换为 AXI 事务，处理通道乱序到达、背压和错误响应。
//
// 建议参数：ADDR_WIDTH=12、DATA_WIDTH=32
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                aclk
//   - input  1                areset_n
//   - input  1                req_valid
//   - output 1                req_ready
//   - input  1                req_write
//   - input  ADDR_WIDTH       req_addr
//   - input  DATA_WIDTH       req_wdata
//   - input  DATA_WIDTH/8     req_wstrb
//   - output 1                rsp_valid
//   - input  1                rsp_ready
//   - output DATA_WIDTH       rsp_rdata
//   - output 2                rsp_resp
//   - output ADDR_WIDTH       m_awaddr
//   - output 1                m_awvalid
//   - input  1                m_awready
//   - output DATA_WIDTH       m_wdata
//   - output DATA_WIDTH/8     m_wstrb
//   - output 1                m_wvalid
//   - input  1                m_wready
//   - input  2                m_bresp
//   - input  1                m_bvalid
//   - output 1                m_bready
//   - output ADDR_WIDTH       m_araddr
//   - output 1                m_arvalid
//   - input  1                m_arready
//   - input  DATA_WIDTH       m_rdata
//   - input  2                m_rresp
//   - input  1                m_rvalid
//   - output 1                m_rready
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=06_bus_protocol/09_axi4_lite_master；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module axi4_lite_master #(
    parameter integer ADDR_WIDTH = 12,
    parameter integer DATA_WIDTH = 32
) (
    input wire aclk,
    input wire areset_n,
    input wire req_valid,
    output reg req_ready,
    input wire req_write,
    input wire [ADDR_WIDTH-1:0] req_addr,
    input wire [DATA_WIDTH-1:0] req_wdata,
    input wire [DATA_WIDTH/8-1:0] req_wstrb,
    output reg rsp_valid,
    input wire rsp_ready,
    output reg [DATA_WIDTH-1:0] rsp_rdata,
    output reg [2-1:0] rsp_resp,
    output reg [ADDR_WIDTH-1:0] m_awaddr,
    output reg m_awvalid,
    input wire m_awready,
    output reg [DATA_WIDTH-1:0] m_wdata,
    output reg [DATA_WIDTH/8-1:0] m_wstrb,
    output reg m_wvalid,
    input wire m_wready,
    input wire [2-1:0] m_bresp,
    input wire m_bvalid,
    output reg m_bready,
    output reg [ADDR_WIDTH-1:0] m_araddr,
    output reg m_arvalid,
    input wire m_arready,
    input wire [DATA_WIDTH-1:0] m_rdata,
    input wire [2-1:0] m_rresp,
    input wire m_rvalid,
    output reg m_rready
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
