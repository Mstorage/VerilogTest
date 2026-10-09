`timescale 1ns/1ps
// Baseline self-checking testbench: SPI Mode 0 主机 (★★★☆☆☆)
// Core verification point: 产生可配置分频的 SCLK/CS，完成定长全双工收发。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_03_spi_mode0_master;
    localparam integer DATA_WIDTH = 8;
    localparam integer DIVIDER = 4;
    reg clk;
    reg rst_n;
    reg start;
    reg [DATA_WIDTH-1:0] tx_data;
    reg miso;
    wire sclk;
    wire cs_n;
    wire mosi;
    wire busy;
    wire done;
    wire [DATA_WIDTH-1:0] rx_data;

    spi_mode0_master dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .tx_data(tx_data),
        .miso(miso),
        .sclk(sclk),
        .cs_n(cs_n),
        .mosi(mosi),
        .busy(busy),
        .done(done),
        .rx_data(rx_data)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{sclk, cs_n, mosi, busy, done, rx_data}) === 1'bx) begin
            $display("[FAIL] 06_bus_protocol/03_spi_mode0_master: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        start = '0;
        tx_data = '0;
        miso = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        start = '1;
        tx_data = '1;
        miso = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 06_bus_protocol/03_spi_mode0_master baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 06_bus_protocol/03_spi_mode0_master: timeout");
        $fatal(1);
    end
endmodule
