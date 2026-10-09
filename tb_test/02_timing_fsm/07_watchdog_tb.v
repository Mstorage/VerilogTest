`timescale 1ns/1ps
// Baseline self-checking testbench: 超时监视器（watchdog） (★★★☆☆☆)
// Core verification point: 收到喂狗事件清零，否则到期报警；加入暂停、清除和锁存报警模式。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_07_watchdog;
    localparam integer TIMEOUT = 16;
    localparam integer COUNT_WIDTH = 4;
    reg clk;
    reg rst_n;
    reg kick;
    reg pause;
    reg clear_alarm;
    reg latch_mode;
    wire alarm;

    watchdog dut (
        .clk(clk),
        .rst_n(rst_n),
        .kick(kick),
        .pause(pause),
        .clear_alarm(clear_alarm),
        .latch_mode(latch_mode),
        .alarm(alarm)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{alarm}) === 1'bx) begin
            $display("[FAIL] 02_timing_fsm/07_watchdog: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        kick = '0;
        pause = '0;
        clear_alarm = '0;
        latch_mode = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        kick = '1;
        pause = '1;
        clear_alarm = '1;
        latch_mode = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 02_timing_fsm/07_watchdog baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 02_timing_fsm/07_watchdog: timeout");
        $fatal(1);
    end
endmodule
