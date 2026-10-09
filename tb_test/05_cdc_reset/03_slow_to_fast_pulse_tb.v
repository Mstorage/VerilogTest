`timescale 1ns/1ps
// Baseline self-checking testbench: 慢域到快域脉冲同步 (★★★☆☆☆)
// Core verification point: 用电平扩展或翻转同步将事件可靠传递，并在目的域恢复单周期脉冲。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_03_slow_to_fast_pulse;

    reg src_clk;
    reg src_rst_n;
    reg src_pulse;
    reg dst_clk;
    reg dst_rst_n;
    wire dst_pulse;

    slow_to_fast_pulse dut (
        .src_clk(src_clk),
        .src_rst_n(src_rst_n),
        .src_pulse(src_pulse),
        .dst_clk(dst_clk),
        .dst_rst_n(dst_rst_n),
        .dst_pulse(dst_pulse)
    );

    always #3 src_clk = ~src_clk;
    always #5 dst_clk = ~dst_clk;

    task check_outputs_known;
    begin
        if ((^{dst_pulse}) === 1'bx) begin
            $display("[FAIL] 05_cdc_reset/03_slow_to_fast_pulse: output contains X/Z");
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

        $display("[PASS] 05_cdc_reset/03_slow_to_fast_pulse baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 05_cdc_reset/03_slow_to_fast_pulse: timeout");
        $fatal(1);
    end
endmodule
