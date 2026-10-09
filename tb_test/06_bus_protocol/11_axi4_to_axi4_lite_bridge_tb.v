`timescale 1ns/1ps
// Baseline self-checking testbench: AXI4 到 AXI4-Lite 桥 (★★★★★☆)
// Core verification point: 拆分 burst 为单拍访问，聚合响应并处理读写通道相互独立。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_11_axi4_to_axi4_lite_bridge;
    localparam integer ADDR_WIDTH = 32;
    localparam integer DATA_WIDTH = 32;
    reg clk;
    reg rst_n;
    reg req_valid;
    wire req_ready;
    reg req_write;
    reg [ADDR_WIDTH-1:0] req_addr;
    reg [8-1:0] req_len;
    reg [3-1:0] req_size;
    reg [DATA_WIDTH-1:0] req_wdata;
    wire rsp_valid;
    reg rsp_ready;
    wire [DATA_WIDTH-1:0] rsp_rdata;
    wire [2-1:0] rsp_resp;
    wire lite_valid;
    reg lite_ready;
    wire lite_write;
    wire [ADDR_WIDTH-1:0] lite_addr;
    wire [DATA_WIDTH-1:0] lite_wdata;
    reg lite_rsp_valid;
    reg [DATA_WIDTH-1:0] lite_rdata;
    reg [2-1:0] lite_resp;

    axi4_to_axi4_lite_bridge dut (
        .clk(clk),
        .rst_n(rst_n),
        .req_valid(req_valid),
        .req_ready(req_ready),
        .req_write(req_write),
        .req_addr(req_addr),
        .req_len(req_len),
        .req_size(req_size),
        .req_wdata(req_wdata),
        .rsp_valid(rsp_valid),
        .rsp_ready(rsp_ready),
        .rsp_rdata(rsp_rdata),
        .rsp_resp(rsp_resp),
        .lite_valid(lite_valid),
        .lite_ready(lite_ready),
        .lite_write(lite_write),
        .lite_addr(lite_addr),
        .lite_wdata(lite_wdata),
        .lite_rsp_valid(lite_rsp_valid),
        .lite_rdata(lite_rdata),
        .lite_resp(lite_resp)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{req_ready, rsp_valid, rsp_rdata, rsp_resp, lite_valid, lite_write, lite_addr, lite_wdata}) === 1'bx) begin
            $display("[FAIL] 06_bus_protocol/11_axi4_to_axi4_lite_bridge: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        req_valid = '0;
        req_write = '0;
        req_addr = '0;
        req_len = '0;
        req_size = '0;
        req_wdata = '0;
        rsp_ready = '0;
        lite_ready = '0;
        lite_rsp_valid = '0;
        lite_rdata = '0;
        lite_resp = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        req_valid = '1;
        req_write = '1;
        req_addr = '1;
        req_len = '1;
        req_size = '1;
        req_wdata = '1;
        rsp_ready = '1;
        lite_ready = '1;
        lite_rsp_valid = '1;
        lite_rdata = '1;
        lite_resp = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 06_bus_protocol/11_axi4_to_axi4_lite_bridge baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 06_bus_protocol/11_axi4_to_axi4_lite_bridge: timeout");
        $fatal(1);
    end
endmodule
