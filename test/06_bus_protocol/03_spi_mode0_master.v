`timescale 1ns/1ps
// ============================================================================
// 题目：SPI Mode 0 主机
// 难度：★★★☆☆☆
// 编号：06_bus_protocol/03_spi_mode0_master
//
// 要求：产生可配置分频的 SCLK/CS，完成定长全双工收发。
//
// 建议参数：DATA_WIDTH=8、DIVIDER=4
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                start
//   - input  DATA_WIDTH       tx_data
//   - input  1                miso
//   - output 1                sclk
//   - output 1                cs_n
//   - output 1                mosi
//   - output 1                busy
//   - output 1                done
//   - output DATA_WIDTH       rx_data
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=06_bus_protocol/03_spi_mode0_master；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module spi_mode0_master #(
    parameter integer DATA_WIDTH = 8,
    parameter integer DIVIDER = 4
) (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [DATA_WIDTH-1:0] tx_data,
    input wire miso,
    output reg sclk,
    output reg cs_n,
    output reg mosi,
    output reg busy,
    output reg done,
    output reg [DATA_WIDTH-1:0] rx_data
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
