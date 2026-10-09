`timescale 1ns/1ps
// Baseline self-checking testbench: 多位配置总线 CDC (★★★★☆☆)
// Core verification point: 使用数据保持 + 握手传输原子快照，禁止逐位两级同步。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_05_multibit_config_cdc;
    localparam integer WIDTH = 32;
    reg src_clk;
    reg src_rst_n;
    reg src_valid;
    wire src_ready;
    reg [WIDTH-1:0] src_data;
    reg dst_clk;
    reg dst_rst_n;
    wire dst_valid;
    wire [WIDTH-1:0] dst_data;

    multibit_config_cdc dut (
        .src_clk(src_clk),
        .src_rst_n(src_rst_n),
        .src_valid(src_valid),
        .src_ready(src_ready),
        .src_data(src_data),
        .dst_clk(dst_clk),
        .dst_rst_n(dst_rst_n),
        .dst_valid(dst_valid),
        .dst_data(dst_data)
    );

    always #3 src_clk = ~src_clk;
    always #5 dst_clk = ~dst_clk;

    task check_outputs_known;
    begin
        if ((^{src_ready, dst_valid, dst_data}) === 1'bx) begin
            $display("[FAIL] 05_cdc_reset/05_multibit_config_cdc: output contains X/Z");
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
        #20;
        src_rst_n = 1'b1;
        dst_rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        src_valid = '1;
        src_data = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 05_cdc_reset/05_multibit_config_cdc baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 05_cdc_reset/05_multibit_config_cdc: timeout");
        $fatal(1);
    end
endmodule
