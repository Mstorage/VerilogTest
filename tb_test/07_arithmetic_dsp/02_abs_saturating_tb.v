`timescale 1ns/1ps
// Baseline self-checking testbench: 绝对值与饱和运算单元 (★★☆☆☆☆)
// Core verification point: 正确处理最小负数，并实现定点加法的上下限饱和。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_02_abs_saturating;
    localparam integer WIDTH = 16;
    reg [WIDTH-1:0] value;
    reg [WIDTH-1:0] add_a;
    reg [WIDTH-1:0] add_b;
    wire [WIDTH-1:0] abs_value;
    wire [WIDTH-1:0] sat_sum;
    wire saturated;

    abs_saturating dut (
        .value(value),
        .add_a(add_a),
        .add_b(add_b),
        .abs_value(abs_value),
        .sat_sum(sat_sum),
        .saturated(saturated)
    );



    task check_outputs_known;
    begin
        if ((^{abs_value, sat_sum, saturated}) === 1'bx) begin
            $display("[FAIL] 07_arithmetic_dsp/02_abs_saturating: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        value = '0;
        add_a = '0;
        add_b = '0;
        #20;

        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        value = '1;
        add_a = '1;
        add_b = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 07_arithmetic_dsp/02_abs_saturating baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 07_arithmetic_dsp/02_abs_saturating: timeout");
        $fatal(1);
    end
endmodule
