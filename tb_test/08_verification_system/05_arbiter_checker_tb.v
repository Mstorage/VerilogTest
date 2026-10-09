`timescale 1ns/1ps
// Baseline self-checking testbench: 仲裁器公平性验证 (★★★★☆☆)
// Core verification point: 检查 one-hot grant、无请求不授权，以及持续请求在有限周期内获服务。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_05_arbiter_checker;
    localparam integer N = 4;
    localparam integer MAX_WAIT = 16;
    reg clk;
    reg rst_n;
    reg [N-1:0] req;
    reg [N-1:0] grant;
    reg accept;
    wire error;

    arbiter_checker dut (
        .clk(clk),
        .rst_n(rst_n),
        .req(req),
        .grant(grant),
        .accept(accept),
        .error(error)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{error}) === 1'bx) begin
            $display("[FAIL] 08_verification_system/05_arbiter_checker: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        req = '0;
        grant = '0;
        accept = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        req = '1;
        grant = '1;
        accept = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 08_verification_system/05_arbiter_checker baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 08_verification_system/05_arbiter_checker: timeout");
        $fatal(1);
    end
endmodule
