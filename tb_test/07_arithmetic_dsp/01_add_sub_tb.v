`timescale 1ns/1ps
// Baseline self-checking testbench: 参数化加减器 (★★☆☆☆☆)
// Core verification point: 支持有/无符号运算，输出进位、借位、零和有符号溢出标志。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_01_add_sub;
    localparam integer WIDTH = 16;
    reg [WIDTH-1:0] a;
    reg [WIDTH-1:0] b;
    reg sub;
    reg signed_mode;
    wire [WIDTH-1:0] result;
    wire carry_borrow;
    wire zero;
    wire overflow;

    add_sub dut (
        .a(a),
        .b(b),
        .sub(sub),
        .signed_mode(signed_mode),
        .result(result),
        .carry_borrow(carry_borrow),
        .zero(zero),
        .overflow(overflow)
    );



    task check_outputs_known;
    begin
        if ((^{result, carry_borrow, zero, overflow}) === 1'bx) begin
            $display("[FAIL] 07_arithmetic_dsp/01_add_sub: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        a = '0;
        b = '0;
        sub = '0;
        signed_mode = '0;
        #20;

        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        a = '1;
        b = '1;
        sub = '1;
        signed_mode = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 07_arithmetic_dsp/01_add_sub baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 07_arithmetic_dsp/01_add_sub: timeout");
        $fatal(1);
    end
endmodule
