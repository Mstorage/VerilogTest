`timescale 1ns/1ps
// Baseline self-checking testbench: 脉冲展宽与可重触发单稳态 (★★☆☆☆☆)
// Core verification point: 将单周期输入展宽为 M 周期，并定义展宽期间再次触发的行为。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_02_pulse_stretcher;
    localparam integer LENGTH = 4;
    localparam integer COUNT_WIDTH = 3;
    reg clk;
    reg rst_n;
    reg trigger;
    reg retrigger_en;
    wire pulse_out;
    wire busy;

    pulse_stretcher dut (
        .clk(clk),
        .rst_n(rst_n),
        .trigger(trigger),
        .retrigger_en(retrigger_en),
        .pulse_out(pulse_out),
        .busy(busy)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{pulse_out, busy}) === 1'bx) begin
            $display("[FAIL] 02_timing_fsm/02_pulse_stretcher: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        trigger = '0;
        retrigger_en = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        trigger = '1;
        retrigger_en = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 02_timing_fsm/02_pulse_stretcher baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 02_timing_fsm/02_pulse_stretcher: timeout");
        $fatal(1);
    end
endmodule
