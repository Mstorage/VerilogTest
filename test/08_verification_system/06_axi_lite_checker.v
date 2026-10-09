`timescale 1ns/1ps
// ============================================================================
// 题目：AXI-Lite 协议检查器
// 难度：★★★★☆☆
// 编号：08_verification_system/06_axi_lite_checker
//
// 要求：为五通道编写关键 SVA，随机化主从背压并覆盖地址/数据错拍到达。
//
// 建议参数：ADDR_WIDTH=12、DATA_WIDTH=32
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                aclk
//   - input  1                areset_n
//   - input  1                awvalid
//   - input  1                awready
//   - input  ADDR_WIDTH       awaddr
//   - input  1                wvalid
//   - input  1                wready
//   - input  DATA_WIDTH       wdata
//   - input  1                bvalid
//   - input  1                bready
//   - input  1                arvalid
//   - input  1                arready
//   - input  ADDR_WIDTH       araddr
//   - input  1                rvalid
//   - input  1                rready
//   - input  DATA_WIDTH       rdata
//   - output 1                error
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=08_verification_system/06_axi_lite_checker；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module axi_lite_checker #(
    parameter integer ADDR_WIDTH = 12,
    parameter integer DATA_WIDTH = 32
) (
    input wire aclk,
    input wire areset_n,
    input wire awvalid,
    input wire awready,
    input wire [ADDR_WIDTH-1:0] awaddr,
    input wire wvalid,
    input wire wready,
    input wire [DATA_WIDTH-1:0] wdata,
    input wire bvalid,
    input wire bready,
    input wire arvalid,
    input wire arready,
    input wire [ADDR_WIDTH-1:0] araddr,
    input wire rvalid,
    input wire rready,
    input wire [DATA_WIDTH-1:0] rdata,
    output reg error
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
