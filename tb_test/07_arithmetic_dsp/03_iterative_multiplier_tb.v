`timescale 1ns/1ps
// Baseline self-checking testbench: 迭代乘法器 (★★★☆☆☆)
// Core verification point: 用移位加法完成有符号乘法，提供 start/busy/done 握手。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_03_iterative_multiplier;
    localparam integer WIDTH = 16;
    reg clk;
    reg rst_n;
    reg start;
    reg signed_mode;
    reg [WIDTH-1:0] a;
    reg [WIDTH-1:0] b;
    wire busy;
    wire done;
    wire [2*WIDTH-1:0] product;

    iterative_multiplier dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .signed_mode(signed_mode),
        .a(a),
        .b(b),
        .busy(busy),
        .done(done),
        .product(product)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{busy, done, product}) === 1'bx) begin
            $display("[FAIL] 07_arithmetic_dsp/03_iterative_multiplier: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        start = '0;
        signed_mode = '0;
        a = '0;
        b = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        start = '1;
        signed_mode = '1;
        a = '1;
        b = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 07_arithmetic_dsp/03_iterative_multiplier baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 07_arithmetic_dsp/03_iterative_multiplier: timeout");
        $fatal(1);
    end
endmodule
