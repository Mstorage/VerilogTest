`timescale 1ns/1ps
// ============================================================================
// 题目：上升沿、下降沿和双边沿检测
// 难度：★★☆☆☆☆
// 编号：01_basic_rtl/06_edge_detector
//
// 要求：对同步输入产生逐位、单周期的 rise/fall/any_edge 脉冲，低有效异步复位清除历史值。
//
// 建议参数：WIDTH=8
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  WIDTH            din
//   - output WIDTH            rise
//   - output WIDTH            fall
//   - output WIDTH            any_edge
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=01_basic_rtl/06_edge_detector；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module edge_detector #(
    parameter integer WIDTH = 8
) (
    input wire clk,
    input wire rst_n,
    input wire [WIDTH-1:0] din,
    output reg [WIDTH-1:0] rise,
    output reg [WIDTH-1:0] fall,
    output reg [WIDTH-1:0] any_edge
);

    reg [WIDTH-1:0] din_q;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            din_q <= {WIDTH{1'b0}};
            rise <= {WIDTH{1'b0}};
            fall <= {WIDTH{1'b0}};
            any_edge <= {WIDTH{1'b0}};
        end else begin
            din_q <= din;
            rise <= ~din_q & din;
            fall <= din_q & ~din;
            any_edge <= din ^ din_q;
        end
    end
endmodule
