`timescale 1ns/1ps
// ============================================================================
// 题目：简单寄存器总线从设备
// 难度：★★☆☆☆☆
// 编号：06_bus_protocol/01_register_bus_slave
//
// 要求：实现地址译码、读写寄存器、只读/写一清零字段和非法地址响应。
//
// 建议参数：ADDR_WIDTH=8、DATA_WIDTH=32
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                req
//   - input  1                write
//   - input  ADDR_WIDTH       addr
//   - input  DATA_WIDTH       wdata
//   - input  DATA_WIDTH       wstrb
//   - output 1                ready
//   - output DATA_WIDTH       rdata
//   - output 1                error
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=06_bus_protocol/01_register_bus_slave；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module register_bus_slave #(
    parameter integer ADDR_WIDTH = 8,
    parameter integer DATA_WIDTH = 32
) (
    input wire clk,
    input wire rst_n,
    input wire req,
    input wire write,
    input wire [ADDR_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] wdata,
    input wire [DATA_WIDTH-1:0] wstrb,
    output reg ready,
    output reg [DATA_WIDTH-1:0] rdata,
    output reg error
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
