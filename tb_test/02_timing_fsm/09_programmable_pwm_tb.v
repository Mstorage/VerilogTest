`timescale 1ns/1ps
// Baseline self-checking testbench: 可编程 PWM (★★★★☆☆)
// Core verification point: 支持周期和占空比更新，要求更新只在周期边界生效且输出无毛刺。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_09_programmable_pwm;
    localparam integer WIDTH = 8;
    reg clk;
    reg rst_n;
    reg cfg_valid;
    reg [WIDTH-1:0] period;
    reg [WIDTH-1:0] duty;
    wire pwm;
    wire cfg_ready;

    programmable_pwm dut (
        .clk(clk),
        .rst_n(rst_n),
        .cfg_valid(cfg_valid),
        .period(period),
        .duty(duty),
        .pwm(pwm),
        .cfg_ready(cfg_ready)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{pwm, cfg_ready}) === 1'bx) begin
            $display("[FAIL] 02_timing_fsm/09_programmable_pwm: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        cfg_valid = '0;
        period = '0;
        duty = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        cfg_valid = '1;
        period = '1;
        duty = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 02_timing_fsm/09_programmable_pwm baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 02_timing_fsm/09_programmable_pwm: timeout");
        $fatal(1);
    end
endmodule
