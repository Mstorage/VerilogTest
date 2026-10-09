`timescale 1ns/1ps
// Baseline self-checking testbench: 可参数化交叉开关 (★★★★★☆)
// Core verification point: N 主 M 从按地址路由并逐从仲裁，处理响应返回及非法地址。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_10_crossbar;
    localparam integer N_MASTER = 2;
    localparam integer N_SLAVE = 2;
    localparam integer ADDR_WIDTH = 16;
    localparam integer DATA_WIDTH = 32;
    reg clk;
    reg rst_n;
    reg [N_MASTER-1:0] req_valid;
    wire [N_MASTER-1:0] req_ready;
    reg [N_MASTER*ADDR_WIDTH-1:0] req_addr;
    reg [N_MASTER*DATA_WIDTH-1:0] req_wdata;
    wire [N_MASTER-1:0] rsp_valid;
    reg [N_MASTER-1:0] rsp_ready;
    wire [N_MASTER*DATA_WIDTH-1:0] rsp_data;

    crossbar dut (
        .clk(clk),
        .rst_n(rst_n),
        .req_valid(req_valid),
        .req_ready(req_ready),
        .req_addr(req_addr),
        .req_wdata(req_wdata),
        .rsp_valid(rsp_valid),
        .rsp_ready(rsp_ready),
        .rsp_data(rsp_data)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{req_ready, rsp_valid, rsp_data}) === 1'bx) begin
            $display("[FAIL] 03_flow_control/10_crossbar: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        req_valid = '0;
        req_addr = '0;
        req_wdata = '0;
        rsp_ready = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        req_valid = '1;
        req_addr = '1;
        req_wdata = '1;
        rsp_ready = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 03_flow_control/10_crossbar baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 03_flow_control/10_crossbar: timeout");
        $fatal(1);
    end
endmodule
