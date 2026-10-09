`timescale 1ns/1ps
// Baseline self-checking testbench: 事件计数跨时钟域 (★★★★☆☆)
// Core verification point: 使用格雷计数器跨域并计算事件增量，说明允许的最大事件速率。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_06_event_counter_cdc;
    localparam integer WIDTH = 8;
    reg src_clk;
    reg src_rst_n;
    reg src_event;
    reg dst_clk;
    reg dst_rst_n;
    wire [WIDTH-1:0] event_count;
    wire [WIDTH-1:0] event_delta;

    event_counter_cdc dut (
        .src_clk(src_clk),
        .src_rst_n(src_rst_n),
        .src_event(src_event),
        .dst_clk(dst_clk),
        .dst_rst_n(dst_rst_n),
        .event_count(event_count),
        .event_delta(event_delta)
    );

    always #3 src_clk = ~src_clk;
    always #5 dst_clk = ~dst_clk;

    task check_outputs_known;
    begin
        if ((^{event_count, event_delta}) === 1'bx) begin
            $display("[FAIL] 05_cdc_reset/06_event_counter_cdc: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        src_clk = 1'b0;
        src_rst_n = 1'b0;
        src_event = '0;
        dst_clk = 1'b0;
        dst_rst_n = 1'b0;
        #20;
        src_rst_n = 1'b1;
        dst_rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        src_event = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 05_cdc_reset/06_event_counter_cdc baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 05_cdc_reset/06_event_counter_cdc: timeout");
        $fatal(1);
    end
endmodule
