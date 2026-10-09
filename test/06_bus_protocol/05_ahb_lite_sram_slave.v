`timescale 1ns/1ps
// ============================================================================
// 题目：AHB-Lite SRAM 从设备
// 难度：★★★★☆☆
// 编号：06_bus_protocol/05_ahb_lite_sram_slave
//
// 要求：正确处理地址/数据流水阶段、读写、等待和错误响应。
//
// 建议参数：ADDR_WIDTH=12、DATA_WIDTH=32、DEPTH=1024
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                hclk
//   - input  1                hreset_n
//   - input  2                htrans
//   - input  1                hwrite
//   - input  3                hsize
//   - input  ADDR_WIDTH       haddr
//   - input  DATA_WIDTH       hwdata
//   - input  1                hready_in
//   - output DATA_WIDTH       hrdata
//   - output 1                hready_out
//   - output 1                hresp
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=06_bus_protocol/05_ahb_lite_sram_slave；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module ahb_lite_sram_slave #(
    parameter integer ADDR_WIDTH = 12,
    parameter integer DATA_WIDTH = 32,
    parameter integer DEPTH = 1024
) (
    input wire hclk,
    input wire hreset_n,
    input wire [2-1:0] htrans,
    input wire hwrite,
    input wire [3-1:0] hsize,
    input wire [ADDR_WIDTH-1:0] haddr,
    input wire [DATA_WIDTH-1:0] hwdata,
    input wire hready_in,
    output reg [DATA_WIDTH-1:0] hrdata,
    output reg hready_out,
    output reg hresp
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
