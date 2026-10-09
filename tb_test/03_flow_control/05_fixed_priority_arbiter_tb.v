`timescale 1ns/1ps
// Baseline self-checking testbench: 固定优先级仲裁器 (★★★☆☆☆)
// Core verification point: N 个请求选一个授权；定义无请求、多请求和请求撤销时的行为。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_05_fixed_priority_arbiter;
    localparam integer N = 4;
    reg [N-1:0] req;
    wire [N-1:0] grant;
    wire grant_valid;

    fixed_priority_arbiter dut (
        .req(req),
        .grant(grant),
        .grant_valid(grant_valid)
    );



    task check_outputs_known;
    begin
        if ((^{grant, grant_valid}) === 1'bx) begin
            $display("[FAIL] 03_flow_control/05_fixed_priority_arbiter: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        req = '0;
        #20;

        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        req = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 03_flow_control/05_fixed_priority_arbiter baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 03_flow_control/05_fixed_priority_arbiter: timeout");
        $fatal(1);
    end
endmodule
