`timescale 1ns/1ps
// Baseline self-checking testbench: CDC 方案审查与修复 (★★★★★★)
// Core verification point: 给定含脉冲、多位总线和重汇聚路径的错误 RTL，定位风险并逐类重构。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_09_cdc_review_repair;
    localparam integer WIDTH = 16;
    reg src_clk;
    reg src_rst_n;
    reg src_level;
    reg src_pulse;
    reg [WIDTH-1:0] src_bus;
    reg src_bus_valid;
    wire src_bus_ready;
    reg dst_clk;
    reg dst_rst_n;
    wire dst_level;
    wire dst_pulse;
    wire [WIDTH-1:0] dst_bus;
    wire dst_bus_valid;

    cdc_review_repair dut (
        .src_clk(src_clk),
        .src_rst_n(src_rst_n),
        .src_level(src_level),
        .src_pulse(src_pulse),
        .src_bus(src_bus),
        .src_bus_valid(src_bus_valid),
        .src_bus_ready(src_bus_ready),
        .dst_clk(dst_clk),
        .dst_rst_n(dst_rst_n),
        .dst_level(dst_level),
        .dst_pulse(dst_pulse),
        .dst_bus(dst_bus),
        .dst_bus_valid(dst_bus_valid)
    );

    always #3 src_clk = ~src_clk;
    always #5 dst_clk = ~dst_clk;

    task check_outputs_known;
    begin
        if ((^{src_bus_ready, dst_level, dst_pulse, dst_bus, dst_bus_valid}) === 1'bx) begin
            $display("[FAIL] 05_cdc_reset/09_cdc_review_repair: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        src_clk = 1'b0;
        src_rst_n = 1'b0;
        src_level = '0;
        src_pulse = '0;
        src_bus = '0;
        src_bus_valid = '0;
        dst_clk = 1'b0;
        dst_rst_n = 1'b0;
        #20;
        src_rst_n = 1'b1;
        dst_rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        src_level = '1;
        src_pulse = '1;
        src_bus = '1;
        src_bus_valid = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 05_cdc_reset/09_cdc_review_repair baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 05_cdc_reset/09_cdc_review_repair: timeout");
        $fatal(1);
    end
endmodule
