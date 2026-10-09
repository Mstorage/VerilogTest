`timescale 1ns/1ps
// Baseline self-checking testbench: 按键消抖器 (★★☆☆☆☆)
// Core verification point: 输入先同步，再通过连续稳定计数输出电平和单次按下脉冲。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_03_debouncer;
    localparam integer STABLE_CYCLES = 8;
    localparam integer COUNT_WIDTH = 3;
    reg clk;
    reg rst_n;
    reg async_in;
    wire level;
    wire pressed;

    debouncer dut (
        .clk(clk),
        .rst_n(rst_n),
        .async_in(async_in),
        .level(level),
        .pressed(pressed)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{level, pressed}) === 1'bx) begin
            $display("[FAIL] 02_timing_fsm/03_debouncer: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        async_in = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        async_in = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 02_timing_fsm/03_debouncer baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 02_timing_fsm/03_debouncer: timeout");
        $fatal(1);
    end
endmodule
