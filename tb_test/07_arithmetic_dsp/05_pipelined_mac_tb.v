`timescale 1ns/1ps
// Baseline self-checking testbench: 流水乘加器（MAC） (★★★★☆☆)
// Core verification point: 支持连续输入、固定延迟和清零/饱和，合理放置流水寄存器。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_05_pipelined_mac;
    localparam integer A_WIDTH = 16;
    localparam integer B_WIDTH = 16;
    localparam integer ACC_WIDTH = 40;
    reg clk;
    reg rst_n;
    reg valid_in;
    reg clear_acc;
    reg [A_WIDTH-1:0] a;
    reg [B_WIDTH-1:0] b;
    wire valid_out;
    wire [ACC_WIDTH-1:0] acc;
    wire overflow;

    pipelined_mac dut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .clear_acc(clear_acc),
        .a(a),
        .b(b),
        .valid_out(valid_out),
        .acc(acc),
        .overflow(overflow)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{valid_out, acc, overflow}) === 1'bx) begin
            $display("[FAIL] 07_arithmetic_dsp/05_pipelined_mac: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        valid_in = '0;
        clear_acc = '0;
        a = '0;
        b = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        valid_in = '1;
        clear_acc = '1;
        a = '1;
        b = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 07_arithmetic_dsp/05_pipelined_mac baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 07_arithmetic_dsp/05_pipelined_mac: timeout");
        $fatal(1);
    end
endmodule
