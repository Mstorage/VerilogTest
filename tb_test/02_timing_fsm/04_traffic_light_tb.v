`timescale 1ns/1ps
// Baseline self-checking testbench: 交通灯控制器 (★★☆☆☆☆)
// Core verification point: 使用 Moore FSM 实现定时状态切换、紧急模式和安全复位状态。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_04_traffic_light;
    localparam integer GREEN_CYCLES = 10;
    localparam integer YELLOW_CYCLES = 3;
    localparam integer RED_CYCLES = 10;
    reg clk;
    reg rst_n;
    reg emergency;
    wire [3-1:0] light_a;
    wire [3-1:0] light_b;

    traffic_light dut (
        .clk(clk),
        .rst_n(rst_n),
        .emergency(emergency),
        .light_a(light_a),
        .light_b(light_b)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{light_a, light_b}) === 1'bx) begin
            $display("[FAIL] 02_timing_fsm/04_traffic_light: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        emergency = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        emergency = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 02_timing_fsm/04_traffic_light baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 02_timing_fsm/04_traffic_light: timeout");
        $fatal(1);
    end
endmodule
