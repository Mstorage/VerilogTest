`timescale 1ns/1ps
// ============================================================================
// 题目：可综合寄存器堆
// 难度：★★★☆☆☆
// 编号：01_basic_rtl/10_register_file
//
// 要求：实现同步写、异步双读口寄存器堆；地址 0 恒为零且忽略写入，低有效异步复位清零。
//
// 建议参数：DATA_WIDTH=32、ADDR_WIDTH=5
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                wen
//   - input  ADDR_WIDTH       waddr
//   - input  DATA_WIDTH       wdata
//   - input  ADDR_WIDTH       raddr1
//   - input  ADDR_WIDTH       raddr2
//   - output DATA_WIDTH       rdata1
//   - output DATA_WIDTH       rdata2
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=01_basic_rtl/10_register_file；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module register_file #(
    parameter integer DATA_WIDTH = 32,
    parameter integer ADDR_WIDTH = 5
) (
    input wire clk,
    input wire rst_n,
    input wire wen,
    input wire [ADDR_WIDTH-1:0] waddr,
    input wire [DATA_WIDTH-1:0] wdata,
    input wire [ADDR_WIDTH-1:0] raddr1,
    input wire [ADDR_WIDTH-1:0] raddr2,
    output reg [DATA_WIDTH-1:0] rdata1,
    output reg [DATA_WIDTH-1:0] rdata2
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
