`timescale 1ns/1ps
// ============================================================================
// 题目：2:1 / 4:1 参数化多路选择器
// 难度：★☆☆☆☆☆
// 编号：01_basic_rtl/01_mux_2_4
//
// 要求：用组合逻辑实现选择，覆盖非法选择值并避免 latch。
//
// 建议参数：WIDTH=8
// 端口列表（方向 / 位宽 / 名称）：
//   - input  WIDTH            in0
//   - input  WIDTH            in1
//   - input  WIDTH            in2
//   - input  WIDTH            in3
//   - input  2                sel
//   - output WIDTH            y
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=01_basic_rtl/01_mux_2_4；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module mux_2_4 #(
    parameter integer WIDTH = 8
) (
    input wire [WIDTH-1:0] in0,
    input wire [WIDTH-1:0] in1,
    input wire [WIDTH-1:0] in2,
    input wire [WIDTH-1:0] in3,
    input wire [2-1:0] sel,
    output reg [WIDTH-1:0] y
);

    always@(*)begin
        if(sel == 2'b00)begin
            y = in0;
        end else if(sel == 2'b01) begin
            y = in1;
        end else if(sel == 2'b10)begin
            y = in2;
        end else begin
            y = in3;
        end  
    end
endmodule
