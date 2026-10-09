`timescale 1ns/1ps
// ============================================================================
// 题目：UART 收发器
// 难度：★★★★☆☆
// 编号：02_timing_fsm/10_uart
//
// 要求：实现波特率发生、8N1 收发、起始位确认、采样和帧错误检测。
//
// 建议参数：CLK_HZ=50000000、BAUD=115200
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                rx
//   - input  1                tx_valid
//   - input  8                tx_data
//   - output 1                tx
//   - output 1                tx_ready
//   - output 1                rx_valid
//   - output 8                rx_data
//   - output 1                frame_error
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=02_timing_fsm/10_uart；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module uart #(
    parameter integer CLK_HZ = 50000000,
    parameter integer BAUD = 115200
) (
    input wire clk,
    input wire rst_n,
    input wire rx,
    input wire tx_valid,
    input wire [8-1:0] tx_data,
    output reg tx,
    output reg tx_ready,
    output reg rx_valid,
    output reg [8-1:0] rx_data,
    output reg frame_error
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
