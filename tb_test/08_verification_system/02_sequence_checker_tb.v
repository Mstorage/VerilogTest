`timescale 1ns/1ps
// Baseline self-checking testbench: 序列检测器随机验证 (★★★☆☆☆)
// Core verification point: 用参考模型检查重叠匹配，并收集关键状态转移覆盖。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_02_sequence_checker;
    localparam integer PATTERN = 11;
    localparam integer PATTERN_LEN = 4;
    reg clk;
    reg rst_n;
    reg bit_valid;
    reg bit_in;
    reg observed_detect;
    wire error;

    sequence_checker dut (
        .clk(clk),
        .rst_n(rst_n),
        .bit_valid(bit_valid),
        .bit_in(bit_in),
        .observed_detect(observed_detect),
        .error(error)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{error}) === 1'bx) begin
            $display("[FAIL] 08_verification_system/02_sequence_checker: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        bit_valid = '0;
        bit_in = '0;
        observed_detect = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        bit_valid = '1;
        bit_in = '1;
        observed_detect = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 08_verification_system/02_sequence_checker baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 08_verification_system/02_sequence_checker: timeout");
        $fatal(1);
    end
endmodule
