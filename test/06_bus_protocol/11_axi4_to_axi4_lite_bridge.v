`timescale 1ns/1ps
// ============================================================================
// 题目：AXI4 到 AXI4-Lite 桥
// 难度：★★★★★☆
// 编号：06_bus_protocol/11_axi4_to_axi4_lite_bridge
//
// 要求：拆分 burst 为单拍访问，聚合响应并处理读写通道相互独立。
//
// 建议参数：ADDR_WIDTH=32、DATA_WIDTH=32
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                req_valid
//   - output 1                req_ready
//   - input  1                req_write
//   - input  ADDR_WIDTH       req_addr
//   - input  8                req_len
//   - input  3                req_size
//   - input  DATA_WIDTH       req_wdata
//   - output 1                rsp_valid
//   - input  1                rsp_ready
//   - output DATA_WIDTH       rsp_rdata
//   - output 2                rsp_resp
//   - output 1                lite_valid
//   - input  1                lite_ready
//   - output 1                lite_write
//   - output ADDR_WIDTH       lite_addr
//   - output DATA_WIDTH       lite_wdata
//   - input  1                lite_rsp_valid
//   - input  DATA_WIDTH       lite_rdata
//   - input  2                lite_resp
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=06_bus_protocol/11_axi4_to_axi4_lite_bridge；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module axi4_to_axi4_lite_bridge #(
    parameter integer ADDR_WIDTH = 32,
    parameter integer DATA_WIDTH = 32
) (
    input wire clk,
    input wire rst_n,
    input wire req_valid,
    output reg req_ready,
    input wire req_write,
    input wire [ADDR_WIDTH-1:0] req_addr,
    input wire [8-1:0] req_len,
    input wire [3-1:0] req_size,
    input wire [DATA_WIDTH-1:0] req_wdata,
    output reg rsp_valid,
    input wire rsp_ready,
    output reg [DATA_WIDTH-1:0] rsp_rdata,
    output reg [2-1:0] rsp_resp,
    output reg lite_valid,
    input wire lite_ready,
    output reg lite_write,
    output reg [ADDR_WIDTH-1:0] lite_addr,
    output reg [DATA_WIDTH-1:0] lite_wdata,
    input wire lite_rsp_valid,
    input wire [DATA_WIDTH-1:0] lite_rdata,
    input wire [2-1:0] lite_resp
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
