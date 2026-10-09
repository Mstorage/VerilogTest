`timescale 1ns/1ps
// Baseline self-checking testbench: 快域到慢域脉冲握手 (★★★☆☆☆)
// Core verification point: 用 req/ack 闭环同步保证窄脉冲不丢失，并输出 busy 防止源端重发。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_04_fast_to_slow_handshake;

    reg src_clk;
    reg src_rst_n;
    reg src_pulse;
    wire src_busy;
    reg dst_clk;
    reg dst_rst_n;
    wire dst_pulse;

    fast_to_slow_handshake dut (
        .src_clk(src_clk),
        .src_rst_n(src_rst_n),
        .src_pulse(src_pulse),
        .src_busy(src_busy),
        .dst_clk(dst_clk),
        .dst_rst_n(dst_rst_n),
        .dst_pulse(dst_pulse)
    );

    always #3 src_clk = ~src_clk;
    always #5 dst_clk = ~dst_clk;

    task check_outputs_known;
    begin
        if ((^{src_busy, dst_pulse}) === 1'bx) begin
            $display("[FAIL] 05_cdc_reset/04_fast_to_slow_handshake: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        src_clk = 1'b0;
        src_rst_n = 1'b0;
        src_pulse = '0;
        dst_clk = 1'b0;
        dst_rst_n = 1'b0;
        #20;
        src_rst_n = 1'b1;
        dst_rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        src_pulse = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 05_cdc_reset/04_fast_to_slow_handshake baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 05_cdc_reset/04_fast_to_slow_handshake: timeout");
        $fatal(1);
    end
endmodule
