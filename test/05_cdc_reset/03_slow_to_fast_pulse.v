`timescale 1ns/1ps
// ============================================================================
// 题目：慢域到快域脉冲同步
// 难度：★★★☆☆☆
// 编号：05_cdc_reset/03_slow_to_fast_pulse
//
// 要求：用电平扩展或翻转同步将事件可靠传递，并在目的域恢复单周期脉冲。
//
// 建议参数：无
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                src_clk
//   - input  1                src_rst_n
//   - input  1                src_pulse
//   - input  1                dst_clk
//   - input  1                dst_rst_n
//   - output 1                dst_pulse
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=05_cdc_reset/03_slow_to_fast_pulse；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module slow_to_fast_pulse (
    input wire src_clk,
    input wire src_rst_n,
    input wire src_pulse,
    input wire dst_clk,
    input wire dst_rst_n,
    output reg dst_pulse
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
