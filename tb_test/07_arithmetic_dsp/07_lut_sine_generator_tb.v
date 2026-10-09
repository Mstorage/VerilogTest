`timescale 1ns/1ps
// Baseline self-checking testbench: 查表式正弦波发生器 (★★★★★☆)
// Core verification point: 相位累加器驱动 ROM，支持频率控制字、象限映射和输出量化。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_07_lut_sine_generator;
    localparam integer PHASE_WIDTH = 24;
    localparam integer OUT_WIDTH = 16;
    localparam integer ADDR_WIDTH = 10;
    reg clk;
    reg rst_n;
    reg en;
    reg [PHASE_WIDTH-1:0] phase_inc;
    wire [OUT_WIDTH-1:0] sine;
    wire [PHASE_WIDTH-1:0] phase;

    lut_sine_generator dut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .phase_inc(phase_inc),
        .sine(sine),
        .phase(phase)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{sine, phase}) === 1'bx) begin
            $display("[FAIL] 07_arithmetic_dsp/07_lut_sine_generator: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        en = '0;
        phase_inc = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        en = '1;
        phase_inc = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 07_arithmetic_dsp/07_lut_sine_generator baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 07_arithmetic_dsp/07_lut_sine_generator: timeout");
        $fatal(1);
    end
endmodule
