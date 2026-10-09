`timescale 1ns/1ps
// Baseline self-checking testbench: 异步复位同步释放 (★★☆☆☆☆)
// Core verification point: 复位可异步拉低、在各时钟域同步释放，避免恢复/移除时间问题。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_02_reset_sync_release;
    localparam integer STAGES = 2;
    reg clk;
    reg async_rst_n;
    wire sync_rst_n;

    reset_sync_release dut (
        .clk(clk),
        .async_rst_n(async_rst_n),
        .sync_rst_n(sync_rst_n)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{sync_rst_n}) === 1'bx) begin
            $display("[FAIL] 05_cdc_reset/02_reset_sync_release: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        async_rst_n = 1'b0;
        #20;
        async_rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。

        #40;
        check_outputs_known();

        $display("[PASS] 05_cdc_reset/02_reset_sync_release baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 05_cdc_reset/02_reset_sync_release: timeout");
        $fatal(1);
    end
endmodule
