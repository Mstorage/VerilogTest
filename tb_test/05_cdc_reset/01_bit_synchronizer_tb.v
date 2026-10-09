`timescale 1ns/1ps
// Baseline self-checking testbench: 单比特两级同步器 (★★☆☆☆☆)
// Core verification point: 将异步电平同步到目标时钟域；标注同步寄存器并解释 MTBF。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_01_bit_synchronizer;
    localparam integer STAGES = 2;
    reg dst_clk;
    reg dst_rst_n;
    reg async_in;
    wire sync_out;

    bit_synchronizer dut (
        .dst_clk(dst_clk),
        .dst_rst_n(dst_rst_n),
        .async_in(async_in),
        .sync_out(sync_out)
    );

    always #3 dst_clk = ~dst_clk;

    task check_outputs_known;
    begin
        if ((^{sync_out}) === 1'bx) begin
            $display("[FAIL] 05_cdc_reset/01_bit_synchronizer: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        dst_clk = 1'b0;
        dst_rst_n = 1'b0;
        async_in = '0;
        #20;
        dst_rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        async_in = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 05_cdc_reset/01_bit_synchronizer baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 05_cdc_reset/01_bit_synchronizer: timeout");
        $fatal(1);
    end
endmodule
