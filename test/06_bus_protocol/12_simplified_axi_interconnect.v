`timescale 1ns/1ps
// ============================================================================
// 题目：简化 AXI4 互连
// 难度：★★★★★★
// 编号：06_bus_protocol/12_simplified_axi_interconnect
//
// 要求：多主多从地址路由、每从仲裁、响应 ID 路由及多笔 outstanding 管理。
//
// 建议参数：N_MASTER=2、N_SLAVE=2、ADDR_WIDTH=32、DATA_WIDTH=32、ID_WIDTH=4
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  N_MASTER         req_valid
//   - output N_MASTER         req_ready
//   - input  N_MASTER*ADDR_WIDTH req_addr
//   - input  N_MASTER*DATA_WIDTH req_data
//   - input  N_MASTER*ID_WIDTH req_id
//   - output N_MASTER         rsp_valid
//   - input  N_MASTER         rsp_ready
//   - output N_MASTER*DATA_WIDTH rsp_data
//   - output N_MASTER*ID_WIDTH rsp_id
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=06_bus_protocol/12_simplified_axi_interconnect；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module simplified_axi_interconnect #(
    parameter integer N_MASTER = 2,
    parameter integer N_SLAVE = 2,
    parameter integer ADDR_WIDTH = 32,
    parameter integer DATA_WIDTH = 32,
    parameter integer ID_WIDTH = 4
) (
    input wire clk,
    input wire rst_n,
    input wire [N_MASTER-1:0] req_valid,
    output reg [N_MASTER-1:0] req_ready,
    input wire [N_MASTER*ADDR_WIDTH-1:0] req_addr,
    input wire [N_MASTER*DATA_WIDTH-1:0] req_data,
    input wire [N_MASTER*ID_WIDTH-1:0] req_id,
    output reg [N_MASTER-1:0] rsp_valid,
    input wire [N_MASTER-1:0] rsp_ready,
    output reg [N_MASTER*DATA_WIDTH-1:0] rsp_data,
    output reg [N_MASTER*ID_WIDTH-1:0] rsp_id
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
