`timescale 1ns/1ps
// ============================================================================
// 题目：AHB-Lite 到 APB 桥
// 难度：★★★★☆☆
// 编号：06_bus_protocol/06_ahb_to_apb_bridge
//
// 要求：将流水 AHB 事务转换为 APB 两阶段事务，加入地址译码和等待传播。
//
// 建议参数：ADDR_WIDTH=16、DATA_WIDTH=32
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                hclk
//   - input  1                hreset_n
//   - input  2                htrans
//   - input  1                hwrite
//   - input  ADDR_WIDTH       haddr
//   - input  DATA_WIDTH       hwdata
//   - output DATA_WIDTH       hrdata
//   - output 1                hready
//   - output 1                hresp
//   - output 1                psel
//   - output 1                penable
//   - output 1                pwrite
//   - output ADDR_WIDTH       paddr
//   - output DATA_WIDTH       pwdata
//   - input  DATA_WIDTH       prdata
//   - input  1                pready
//   - input  1                pslverr
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=06_bus_protocol/06_ahb_to_apb_bridge；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module ahb_to_apb_bridge #(
    parameter integer ADDR_WIDTH = 16,
    parameter integer DATA_WIDTH = 32
) (
    input wire hclk,
    input wire hreset_n,
    input wire [2-1:0] htrans,
    input wire hwrite,
    input wire [ADDR_WIDTH-1:0] haddr,
    input wire [DATA_WIDTH-1:0] hwdata,
    output reg [DATA_WIDTH-1:0] hrdata,
    output reg hready,
    output reg hresp,
    output reg psel,
    output reg penable,
    output reg pwrite,
    output reg [ADDR_WIDTH-1:0] paddr,
    output reg [DATA_WIDTH-1:0] pwdata,
    input wire [DATA_WIDTH-1:0] prdata,
    input wire pready,
    input wire pslverr
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
