`timescale 1ns/1ps
// ============================================================================
// 题目：CRC 生成与校验
// 难度：★★★★★☆
// 编号：07_arithmetic_dsp/09_crc
//
// 要求：根据给定多项式实现串行版和并行版，明确初值、反射与异或约定。
//
// 建议参数：DATA_WIDTH=8、CRC_WIDTH=16、POLY=4129、INIT=65535
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                init
//   - input  1                data_valid
//   - input  DATA_WIDTH       data
//   - input  1                check
//   - output CRC_WIDTH        crc
//   - output 1                crc_ok
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=07_arithmetic_dsp/09_crc；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module crc_unit #(
    parameter integer DATA_WIDTH = 8,
    parameter integer CRC_WIDTH = 16,
    parameter integer POLY = 4129,
    parameter integer INIT = 65535
) (
    input wire clk,
    input wire rst_n,
    input wire init,
    input wire data_valid,
    input wire [DATA_WIDTH-1:0] data,
    input wire check,
    output reg [CRC_WIDTH-1:0] crc,
    output reg crc_ok
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
