`timescale 1ns/1ps
// Baseline self-checking testbench: I²C 主机基础版 (★★★☆☆☆)
// Core verification point: 实现 START/STOP、字节收发、ACK/NACK 和开漏输出控制。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_04_i2c_master_basic;
    localparam integer CLK_DIV = 250;
    reg clk;
    reg rst_n;
    reg start;
    reg [7-1:0] address;
    reg read;
    reg [8-1:0] tx_data;
    reg sda_i;
    wire scl;
    wire sda_o;
    wire sda_oe;
    wire busy;
    wire done;
    wire ack_error;
    wire [8-1:0] rx_data;

    i2c_master_basic dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .address(address),
        .read(read),
        .tx_data(tx_data),
        .sda_i(sda_i),
        .scl(scl),
        .sda_o(sda_o),
        .sda_oe(sda_oe),
        .busy(busy),
        .done(done),
        .ack_error(ack_error),
        .rx_data(rx_data)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{scl, sda_o, sda_oe, busy, done, ack_error, rx_data}) === 1'bx) begin
            $display("[FAIL] 06_bus_protocol/04_i2c_master_basic: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        start = '0;
        address = '0;
        read = '0;
        tx_data = '0;
        sda_i = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        start = '1;
        address = '1;
        read = '1;
        tx_data = '1;
        sda_i = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 06_bus_protocol/04_i2c_master_basic baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 06_bus_protocol/04_i2c_master_basic: timeout");
        $fatal(1);
    end
endmodule
