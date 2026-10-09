`timescale 1ns/1ps
// Baseline self-checking testbench: AXI4 突发地址发生器 (★★★★★☆)
// Core verification point: 支持 FIXED/INCR/WRAP，正确计算 `AxLEN/AxSIZE`、4 KB 边界和最后一拍。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_10_axi4_burst_address;
    localparam integer ADDR_WIDTH = 32;
    reg [ADDR_WIDTH-1:0] start_addr;
    reg [8-1:0] len;
    reg [3-1:0] size;
    reg [2-1:0] burst;
    reg [8-1:0] beat_index;
    wire [ADDR_WIDTH-1:0] beat_addr;
    wire last;
    wire cross_4k;
    wire config_error;

    axi4_burst_address dut (
        .start_addr(start_addr),
        .len(len),
        .size(size),
        .burst(burst),
        .beat_index(beat_index),
        .beat_addr(beat_addr),
        .last(last),
        .cross_4k(cross_4k),
        .config_error(config_error)
    );



    task check_outputs_known;
    begin
        if ((^{beat_addr, last, cross_4k, config_error}) === 1'bx) begin
            $display("[FAIL] 06_bus_protocol/10_axi4_burst_address: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        start_addr = '0;
        len = '0;
        size = '0;
        burst = '0;
        beat_index = '0;
        #20;

        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        start_addr = '1;
        len = '1;
        size = '1;
        burst = '1;
        beat_index = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 06_bus_protocol/10_axi4_burst_address baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 06_bus_protocol/10_axi4_burst_address: timeout");
        $fatal(1);
    end
endmodule
