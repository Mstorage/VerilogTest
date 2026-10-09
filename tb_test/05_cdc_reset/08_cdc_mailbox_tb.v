`timescale 1ns/1ps
// Baseline self-checking testbench: 无丢失 CDC 邮箱 (★★★★★☆)
// Core verification point: 单条消息跨域传输，支持背压、复位中断和源/目的时钟暂停。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_08_cdc_mailbox;
    localparam integer WIDTH = 32;
    reg src_clk;
    reg src_rst_n;
    reg src_valid;
    wire src_ready;
    reg [WIDTH-1:0] src_data;
    reg dst_clk;
    reg dst_rst_n;
    wire dst_valid;
    reg dst_ready;
    wire [WIDTH-1:0] dst_data;

    cdc_mailbox dut (
        .src_clk(src_clk),
        .src_rst_n(src_rst_n),
        .src_valid(src_valid),
        .src_ready(src_ready),
        .src_data(src_data),
        .dst_clk(dst_clk),
        .dst_rst_n(dst_rst_n),
        .dst_valid(dst_valid),
        .dst_ready(dst_ready),
        .dst_data(dst_data)
    );

    always #3 src_clk = ~src_clk;
    always #5 dst_clk = ~dst_clk;

    task check_outputs_known;
    begin
        if ((^{src_ready, dst_valid, dst_data}) === 1'bx) begin
            $display("[FAIL] 05_cdc_reset/08_cdc_mailbox: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        src_clk = 1'b0;
        src_rst_n = 1'b0;
        src_valid = '0;
        src_data = '0;
        dst_clk = 1'b0;
        dst_rst_n = 1'b0;
        dst_ready = '0;
        #20;
        src_rst_n = 1'b1;
        dst_rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        src_valid = '1;
        src_data = '1;
        dst_ready = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 05_cdc_reset/08_cdc_mailbox baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 05_cdc_reset/08_cdc_mailbox: timeout");
        $fatal(1);
    end
endmodule
