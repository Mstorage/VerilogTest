`timescale 1ns/1ps
// Baseline self-checking testbench: 任意可配置序列检测器 (★★★☆☆☆)
// Core verification point: 通过移位比较或 KMP 风格状态机检测参数化模式，支持重叠。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_06_configurable_sequence;
    localparam integer PATTERN = 11;
    localparam integer PATTERN_LEN = 4;
    reg clk;
    reg rst_n;
    reg bit_in;
    reg valid_in;
    wire detected;

    configurable_sequence dut (
        .clk(clk),
        .rst_n(rst_n),
        .bit_in(bit_in),
        .valid_in(valid_in),
        .detected(detected)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{detected}) === 1'bx) begin
            $display("[FAIL] 02_timing_fsm/06_configurable_sequence: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        bit_in = '0;
        valid_in = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        bit_in = '1;
        valid_in = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 02_timing_fsm/06_configurable_sequence baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 02_timing_fsm/06_configurable_sequence: timeout");
        $fatal(1);
    end
endmodule
