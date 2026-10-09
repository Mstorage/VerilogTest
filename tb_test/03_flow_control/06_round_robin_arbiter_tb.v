`timescale 1ns/1ps
// Baseline self-checking testbench: 轮询（Round-Robin）仲裁器 (★★★☆☆☆)
// Core verification point: 每次成功服务后更新优先级，保证持续请求者不会饿死。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_06_round_robin_arbiter;
    localparam integer N = 4;
    reg clk;
    reg rst_n;
    reg [N-1:0] req;
    reg accept;
    wire [N-1:0] grant;
    wire grant_valid;

    round_robin_arbiter dut (
        .clk(clk),
        .rst_n(rst_n),
        .req(req),
        .accept(accept),
        .grant(grant),
        .grant_valid(grant_valid)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{grant, grant_valid}) === 1'bx) begin
            $display("[FAIL] 03_flow_control/06_round_robin_arbiter: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        req = '0;
        accept = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        req = '1;
        accept = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 03_flow_control/06_round_robin_arbiter baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 03_flow_control/06_round_robin_arbiter: timeout");
        $fatal(1);
    end
endmodule
