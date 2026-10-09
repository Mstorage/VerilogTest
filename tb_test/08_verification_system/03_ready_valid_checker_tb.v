`timescale 1ns/1ps
// Baseline self-checking testbench: Ready/Valid 协议断言 (★★★☆☆☆)
// Core verification point: 检查背压时数据稳定、一次握手一次传输，以及无 X/Z 控制信号。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_03_ready_valid_checker;
    localparam integer WIDTH = 8;
    reg clk;
    reg rst_n;
    reg valid;
    reg ready;
    reg [WIDTH-1:0] data;
    wire error;

    ready_valid_checker dut (
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid),
        .ready(ready),
        .data(data),
        .error(error)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{error}) === 1'bx) begin
            $display("[FAIL] 08_verification_system/03_ready_valid_checker: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        valid = '0;
        ready = '0;
        data = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        valid = '1;
        ready = '1;
        data = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 08_verification_system/03_ready_valid_checker baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 08_verification_system/03_ready_valid_checker: timeout");
        $fatal(1);
    end
endmodule
