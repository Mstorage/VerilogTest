`timescale 1ns/1ps
// ============================================================================
// 题目：单比特两级同步器
// 难度：★★☆☆☆☆
// 编号：05_cdc_reset/01_bit_synchronizer
//
// 要求：将异步电平同步到目标时钟域；标注同步寄存器并解释 MTBF。
//
// 建议参数：STAGES=2
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                dst_clk
//   - input  1                dst_rst_n
//   - input  1                async_in
//   - output 1                sync_out
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=05_cdc_reset/01_bit_synchronizer；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module bit_synchronizer #(
    parameter integer STAGES = 2
) (
    input wire dst_clk,
    input wire dst_rst_n,
    input wire async_in,
    output reg sync_out
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
