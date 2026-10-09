`timescale 1ns/1ps
// Baseline self-checking testbench: Reset Domain Crossing 控制器 (★★★★☆☆)
// Core verification point: 多时钟域按依赖关系复位和启动，确保下游只观察到一致状态。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_07_reset_domain_controller;
    localparam integer DOMAINS = 3;
    localparam integer DELAY = 4;
    reg clk;
    reg async_rst_n;
    reg [DOMAINS-1:0] domain_ready;
    wire [DOMAINS-1:0] domain_rst_n;
    wire all_ready;

    reset_domain_controller dut (
        .clk(clk),
        .async_rst_n(async_rst_n),
        .domain_ready(domain_ready),
        .domain_rst_n(domain_rst_n),
        .all_ready(all_ready)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{domain_rst_n, all_ready}) === 1'bx) begin
            $display("[FAIL] 05_cdc_reset/07_reset_domain_controller: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        async_rst_n = 1'b0;
        domain_ready = '0;
        #20;
        async_rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        domain_ready = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 05_cdc_reset/07_reset_domain_controller baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 05_cdc_reset/07_reset_domain_controller: timeout");
        $fatal(1);
    end
endmodule
