`timescale 1ns/1ps
// ============================================================================
// 题目：Reset Domain Crossing 控制器
// 难度：★★★★☆☆
// 编号：05_cdc_reset/07_reset_domain_controller
//
// 要求：多时钟域按依赖关系复位和启动，确保下游只观察到一致状态。
//
// 建议参数：DOMAINS=3、DELAY=4
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                async_rst_n
//   - input  DOMAINS          domain_ready
//   - output DOMAINS          domain_rst_n
//   - output 1                all_ready
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=05_cdc_reset/07_reset_domain_controller；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module reset_domain_controller #(
    parameter integer DOMAINS = 3,
    parameter integer DELAY = 4
) (
    input wire clk,
    input wire async_rst_n,
    input wire [DOMAINS-1:0] domain_ready,
    output reg [DOMAINS-1:0] domain_rst_n,
    output reg all_ready
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
