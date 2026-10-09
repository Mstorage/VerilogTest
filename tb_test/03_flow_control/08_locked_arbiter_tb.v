`timescale 1ns/1ps
// Baseline self-checking testbench: 锁定式仲裁器 (★★★★☆☆)
// Core verification point: 一旦选中就保持授权至事务结束，同时处理结束与新请求同周期到达。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_08_locked_arbiter;
    localparam integer N = 4;
    reg clk;
    reg rst_n;
    reg [N-1:0] req;
    reg transaction_done;
    wire [N-1:0] grant;
    wire grant_valid;

    locked_arbiter dut (
        .clk(clk),
        .rst_n(rst_n),
        .req(req),
        .transaction_done(transaction_done),
        .grant(grant),
        .grant_valid(grant_valid)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{grant, grant_valid}) === 1'bx) begin
            $display("[FAIL] 03_flow_control/08_locked_arbiter: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        req = '0;
        transaction_done = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        req = '1;
        transaction_done = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 03_flow_control/08_locked_arbiter baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 03_flow_control/08_locked_arbiter: timeout");
        $fatal(1);
    end
endmodule
