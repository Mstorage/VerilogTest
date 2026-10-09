`timescale 1ns/1ps
// ============================================================================
// 题目：快域到慢域脉冲握手
// 难度：★★★☆☆☆
// 编号：05_cdc_reset/04_fast_to_slow_handshake
//
// 要求：用 req/ack 闭环同步保证窄脉冲不丢失，并输出 busy 防止源端重发。
//
// 建议参数：无
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                src_clk
//   - input  1                src_rst_n
//   - input  1                src_pulse
//   - output 1                src_busy
//   - input  1                dst_clk
//   - input  1                dst_rst_n
//   - output 1                dst_pulse
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=05_cdc_reset/04_fast_to_slow_handshake；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module fast_to_slow_handshake (
    input wire src_clk,
    input wire src_rst_n,
    input wire src_pulse,
    output reg src_busy,
    input wire dst_clk,
    input wire dst_rst_n,
    output reg dst_pulse
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
