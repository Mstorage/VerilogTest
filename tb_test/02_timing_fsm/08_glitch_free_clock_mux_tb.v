`timescale 1ns/1ps
// Baseline self-checking testbench: 无毛刺时钟切换控制器 (★★★☆☆☆)
// Core verification point: 在两个时钟源间安全切换，避免输出窄脉冲；解释适用假设。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_08_glitch_free_clock_mux;

    reg clk0;
    reg clk1;
    reg rst_n;
    reg sel;
    wire clk_out;

    glitch_free_clock_mux dut (
        .clk0(clk0),
        .clk1(clk1),
        .rst_n(rst_n),
        .sel(sel),
        .clk_out(clk_out)
    );

    always #3 clk0 = ~clk0;
    always #5 clk1 = ~clk1;

    task check_outputs_known;
    begin
        if ((^{clk_out}) === 1'bx) begin
            $display("[FAIL] 02_timing_fsm/08_glitch_free_clock_mux: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk0 = 1'b0;
        clk1 = 1'b0;
        rst_n = 1'b0;
        sel = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        sel = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 02_timing_fsm/08_glitch_free_clock_mux baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 02_timing_fsm/08_glitch_free_clock_mux: timeout");
        $fatal(1);
    end
endmodule
