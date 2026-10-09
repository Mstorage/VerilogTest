`timescale 1ns/1ps
// ============================================================================
// 题目：奇偶校验产生与检测
// 难度：★☆☆☆☆☆
// 编号：01_basic_rtl/03_parity
//
// 要求：为参数化数据宽度生成偶校验位，并检查接收数据是否出错。
//
// 建议参数：WIDTH=8
// 端口列表（方向 / 位宽 / 名称）：
//   - input  WIDTH            data
//   - input  WIDTH            rx_data
//   - input  1                rx_parity
//   - output 1                parity_even
//   - output 1                error
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=01_basic_rtl/03_parity；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module parity_unit #(
    parameter integer WIDTH = 8
) (
    input wire [WIDTH-1:0] data,
    input wire [WIDTH-1:0] rx_data,
    input wire rx_parity,
    output reg parity_even,
    output reg error
);

    integer i;

    always @(*) begin
        parity_even = ^data;
        error       = (^rx_data) != rx_parity;
    end

endmodule
