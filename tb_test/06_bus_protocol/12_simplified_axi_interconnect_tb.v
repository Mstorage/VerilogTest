`timescale 1ns/1ps
// Baseline self-checking testbench: 简化 AXI4 互连 (★★★★★★)
// Core verification point: 多主多从地址路由、每从仲裁、响应 ID 路由及多笔 outstanding 管理。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_12_simplified_axi_interconnect;
    localparam integer N_MASTER = 2;
    localparam integer N_SLAVE = 2;
    localparam integer ADDR_WIDTH = 32;
    localparam integer DATA_WIDTH = 32;
    localparam integer ID_WIDTH = 4;
    reg clk;
    reg rst_n;
    reg [N_MASTER-1:0] req_valid;
    wire [N_MASTER-1:0] req_ready;
    reg [N_MASTER*ADDR_WIDTH-1:0] req_addr;
    reg [N_MASTER*DATA_WIDTH-1:0] req_data;
    reg [N_MASTER*ID_WIDTH-1:0] req_id;
    wire [N_MASTER-1:0] rsp_valid;
    reg [N_MASTER-1:0] rsp_ready;
    wire [N_MASTER*DATA_WIDTH-1:0] rsp_data;
    wire [N_MASTER*ID_WIDTH-1:0] rsp_id;

    simplified_axi_interconnect dut (
        .clk(clk),
        .rst_n(rst_n),
        .req_valid(req_valid),
        .req_ready(req_ready),
        .req_addr(req_addr),
        .req_data(req_data),
        .req_id(req_id),
        .rsp_valid(rsp_valid),
        .rsp_ready(rsp_ready),
        .rsp_data(rsp_data),
        .rsp_id(rsp_id)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{req_ready, rsp_valid, rsp_data, rsp_id}) === 1'bx) begin
            $display("[FAIL] 06_bus_protocol/12_simplified_axi_interconnect: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        req_valid = '0;
        req_addr = '0;
        req_data = '0;
        req_id = '0;
        rsp_ready = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        req_valid = '1;
        req_addr = '1;
        req_data = '1;
        req_id = '1;
        rsp_ready = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 06_bus_protocol/12_simplified_axi_interconnect baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 06_bus_protocol/12_simplified_axi_interconnect: timeout");
        $fatal(1);
    end
endmodule
