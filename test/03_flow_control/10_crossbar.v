`timescale 1ns/1ps
// ============================================================================
// 题目：可参数化交叉开关
// 难度：★★★★★☆
// 编号：03_flow_control/10_crossbar
//
// 要求：N 主 M 从按地址路由并逐从仲裁，处理响应返回及非法地址。
//
// 建议参数：N_MASTER=2、N_SLAVE=2、ADDR_WIDTH=16、DATA_WIDTH=32
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  N_MASTER         req_valid
//   - output N_MASTER         req_ready
//   - input  N_MASTER*ADDR_WIDTH req_addr
//   - input  N_MASTER*DATA_WIDTH req_wdata
//   - output N_MASTER         rsp_valid
//   - input  N_MASTER         rsp_ready
//   - output N_MASTER*DATA_WIDTH rsp_data
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=03_flow_control/10_crossbar；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module crossbar #(
    parameter integer N_MASTER = 2,
    parameter integer N_SLAVE = 2,
    parameter integer ADDR_WIDTH = 16,
    parameter integer DATA_WIDTH = 32
) (
    input wire clk,
    input wire rst_n,
    input wire [N_MASTER-1:0] req_valid,
    output reg [N_MASTER-1:0] req_ready,
    input wire [N_MASTER*ADDR_WIDTH-1:0] req_addr,
    input wire [N_MASTER*DATA_WIDTH-1:0] req_wdata,
    output reg [N_MASTER-1:0] rsp_valid,
    input wire [N_MASTER-1:0] rsp_ready,
    output reg [N_MASTER*DATA_WIDTH-1:0] rsp_data
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
