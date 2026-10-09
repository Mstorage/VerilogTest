`timescale 1ns/1ps
// ============================================================================
// 题目：AXI4 突发地址发生器
// 难度：★★★★★☆
// 编号：06_bus_protocol/10_axi4_burst_address
//
// 要求：支持 FIXED/INCR/WRAP，正确计算 `AxLEN/AxSIZE`、4 KB 边界和最后一拍。
//
// 建议参数：ADDR_WIDTH=32
// 端口列表（方向 / 位宽 / 名称）：
//   - input  ADDR_WIDTH       start_addr
//   - input  8                len
//   - input  3                size
//   - input  2                burst
//   - input  8                beat_index
//   - output ADDR_WIDTH       beat_addr
//   - output 1                last
//   - output 1                cross_4k
//   - output 1                config_error
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=06_bus_protocol/10_axi4_burst_address；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module axi4_burst_address #(
    parameter integer ADDR_WIDTH = 32
) (
    input wire [ADDR_WIDTH-1:0] start_addr,
    input wire [8-1:0] len,
    input wire [3-1:0] size,
    input wire [2-1:0] burst,
    input wire [8-1:0] beat_index,
    output reg [ADDR_WIDTH-1:0] beat_addr,
    output reg last,
    output reg cross_4k,
    output reg config_error
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
