`timescale 1ns/1ps
// ============================================================================
// 题目：APB3 从设备
// 难度：★★★☆☆☆
// 编号：06_bus_protocol/02_apb3_slave
//
// 要求：实现 SETUP/ACCESS 两阶段传输、等待状态和错误响应。
//
// 建议参数：ADDR_WIDTH=12、DATA_WIDTH=32
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                pclk
//   - input  1                preset_n
//   - input  1                psel
//   - input  1                penable
//   - input  1                pwrite
//   - input  ADDR_WIDTH       paddr
//   - input  DATA_WIDTH       pwdata
//   - output DATA_WIDTH       prdata
//   - output 1                pready
//   - output 1                pslverr
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=06_bus_protocol/02_apb3_slave；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module apb3_slave #(
    parameter integer ADDR_WIDTH = 12,
    parameter integer DATA_WIDTH = 32
) (
    input wire pclk,
    input wire preset_n,
    input wire psel,
    input wire penable,
    input wire pwrite,
    input wire [ADDR_WIDTH-1:0] paddr,
    input wire [DATA_WIDTH-1:0] pwdata,
    output reg [DATA_WIDTH-1:0] prdata,
    output reg pready,
    output reg pslverr
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
