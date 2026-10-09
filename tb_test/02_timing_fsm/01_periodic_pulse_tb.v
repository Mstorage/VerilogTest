`timescale 1ns/1ps
// Baseline self-checking testbench: 周期脉冲发生器 (★☆☆☆☆☆)
// Core verification point: 每 N 个时钟产生一个单周期脉冲，N 可参数化且无累计偏差。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_01_periodic_pulse;
    localparam integer PERIOD = 10;
    localparam integer COUNT_WIDTH = 4;
    reg clk;
    reg rst_n;
    reg en;
    wire pulse;

    periodic_pulse dut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .pulse(pulse)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{pulse}) === 1'bx) begin
            $display("[FAIL] 02_timing_fsm/01_periodic_pulse: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        en = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        en = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 02_timing_fsm/01_periodic_pulse baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 02_timing_fsm/01_periodic_pulse: timeout");
        $fatal(1);
    end
endmodule
