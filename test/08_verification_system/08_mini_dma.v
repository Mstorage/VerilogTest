`timescale 1ns/1ps
// ============================================================================
// 题目：Mini-DMA 综合项目
// 难度：★★★★★★
// 编号：08_verification_system/08_mini_dma
//
// 要求：从 AXI4-Lite 寄存器取配置，经 AXI/简化存储接口搬运数据，以 Stream 输出；集成 FIFO、仲裁、错误与中断。
//
// 建议参数：ADDR_WIDTH=32、DATA_WIDTH=32、LENGTH_WIDTH=16
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                cfg_start
//   - input  ADDR_WIDTH       cfg_src_addr
//   - input  LENGTH_WIDTH     cfg_length
//   - output 1                busy
//   - output 1                done
//   - output 1                error
//   - output 1                mem_req_valid
//   - input  1                mem_req_ready
//   - output ADDR_WIDTH       mem_req_addr
//   - input  1                mem_rsp_valid
//   - input  DATA_WIDTH       mem_rsp_data
//   - output 1                stream_valid
//   - input  1                stream_ready
//   - output DATA_WIDTH       stream_data
//   - output 1                stream_last
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=08_verification_system/08_mini_dma；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module mini_dma #(
    parameter integer ADDR_WIDTH = 32,
    parameter integer DATA_WIDTH = 32,
    parameter integer LENGTH_WIDTH = 16
) (
    input wire clk,
    input wire rst_n,
    input wire cfg_start,
    input wire [ADDR_WIDTH-1:0] cfg_src_addr,
    input wire [LENGTH_WIDTH-1:0] cfg_length,
    output reg busy,
    output reg done,
    output reg error,
    output reg mem_req_valid,
    input wire mem_req_ready,
    output reg [ADDR_WIDTH-1:0] mem_req_addr,
    input wire mem_rsp_valid,
    input wire [DATA_WIDTH-1:0] mem_rsp_data,
    output reg stream_valid,
    input wire stream_ready,
    output reg [DATA_WIDTH-1:0] stream_data,
    output reg stream_last
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
