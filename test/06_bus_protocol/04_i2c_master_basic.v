`timescale 1ns/1ps
// ============================================================================
// 题目：I²C 主机基础版
// 难度：★★★☆☆☆
// 编号：06_bus_protocol/04_i2c_master_basic
//
// 要求：实现 START/STOP、字节收发、ACK/NACK 和开漏输出控制。
//
// 建议参数：CLK_DIV=250
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                start
//   - input  7                address
//   - input  1                read
//   - input  8                tx_data
//   - input  1                sda_i
//   - output 1                scl
//   - output 1                sda_o
//   - output 1                sda_oe
//   - output 1                busy
//   - output 1                done
//   - output 1                ack_error
//   - output 8                rx_data
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=06_bus_protocol/04_i2c_master_basic；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module i2c_master_basic #(
    parameter integer CLK_DIV = 250
) (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [7-1:0] address,
    input wire read,
    input wire [8-1:0] tx_data,
    input wire sda_i,
    output reg scl,
    output reg sda_o,
    output reg sda_oe,
    output reg busy,
    output reg done,
    output reg ack_error,
    output reg [8-1:0] rx_data
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
