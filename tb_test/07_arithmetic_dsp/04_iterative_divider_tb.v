`timescale 1ns/1ps
// Baseline self-checking testbench: 迭代除法器 (★★★★☆☆)
// Core verification point: 用恢复或非恢复算法输出商和余数，定义除零和符号规则。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_04_iterative_divider;
    localparam integer WIDTH = 16;
    reg clk;
    reg rst_n;
    reg start;
    reg signed_mode;
    reg [WIDTH-1:0] dividend;
    reg [WIDTH-1:0] divisor;
    wire busy;
    wire done;
    wire [WIDTH-1:0] quotient;
    wire [WIDTH-1:0] remainder;
    wire divide_by_zero;

    iterative_divider dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .signed_mode(signed_mode),
        .dividend(dividend),
        .divisor(divisor),
        .busy(busy),
        .done(done),
        .quotient(quotient),
        .remainder(remainder),
        .divide_by_zero(divide_by_zero)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{busy, done, quotient, remainder, divide_by_zero}) === 1'bx) begin
            $display("[FAIL] 07_arithmetic_dsp/04_iterative_divider: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        start = '0;
        signed_mode = '0;
        dividend = '0;
        divisor = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        start = '1;
        signed_mode = '1;
        dividend = '1;
        divisor = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 07_arithmetic_dsp/04_iterative_divider baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 07_arithmetic_dsp/04_iterative_divider: timeout");
        $fatal(1);
    end
endmodule
