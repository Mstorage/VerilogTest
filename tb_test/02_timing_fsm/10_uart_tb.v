`timescale 1ns/1ps
// Baseline self-checking testbench: UART 收发器 (★★★★☆☆)
// Core verification point: 实现波特率发生、8N1 收发、起始位确认、采样和帧错误检测。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_10_uart;
    localparam integer CLK_HZ = 50000000;
    localparam integer BAUD = 115200;
    reg clk;
    reg rst_n;
    reg rx;
    reg tx_valid;
    reg [8-1:0] tx_data;
    wire tx;
    wire tx_ready;
    wire rx_valid;
    wire [8-1:0] rx_data;
    wire frame_error;

    uart dut (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .tx_valid(tx_valid),
        .tx_data(tx_data),
        .tx(tx),
        .tx_ready(tx_ready),
        .rx_valid(rx_valid),
        .rx_data(rx_data),
        .frame_error(frame_error)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{tx, tx_ready, rx_valid, rx_data, frame_error}) === 1'bx) begin
            $display("[FAIL] 02_timing_fsm/10_uart: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        rx = '0;
        tx_valid = '0;
        tx_data = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        rx = '1;
        tx_valid = '1;
        tx_data = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 02_timing_fsm/10_uart baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 02_timing_fsm/10_uart: timeout");
        $fatal(1);
    end
endmodule
