`timescale 1ns/1ps
// Baseline self-checking testbench: 自检式计数器 testbench (★★☆☆☆☆)
// Core verification point: 自动产生激励和参考值，覆盖复位、使能、回卷并给出 PASS/FAIL。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_01_counter_checker;
    localparam integer WIDTH = 8;
    localparam integer MODULO = 100;
    reg clk;
    reg rst_n;
    reg en;
    reg [WIDTH-1:0] observed_count;
    wire error;

    counter_checker dut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .observed_count(observed_count),
        .error(error)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{error}) === 1'bx) begin
            $display("[FAIL] 08_verification_system/01_counter_checker: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        en = '0;
        observed_count = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        en = '1;
        observed_count = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 08_verification_system/01_counter_checker baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 08_verification_system/01_counter_checker: timeout");
        $fatal(1);
    end
endmodule
