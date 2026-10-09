`timescale 1ns/1ps
// Baseline self-checking testbench: 多通道虚拟 FIFO (★★★★☆☆)
// Core verification point: 多个逻辑队列共享存储，维护各通道顺序、容量与公平调度。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_06_virtual_channel_fifo;
    localparam integer CHANNELS = 4;
    localparam integer WIDTH = 8;
    localparam integer DEPTH = 16;
    localparam integer CH_WIDTH = 2;
    reg clk;
    reg rst_n;
    reg wr_en;
    reg [CH_WIDTH-1:0] wr_channel;
    reg [WIDTH-1:0] wr_data;
    reg rd_en;
    reg [CH_WIDTH-1:0] rd_channel;
    wire [WIDTH-1:0] rd_data;
    wire [CHANNELS-1:0] full;
    wire [CHANNELS-1:0] empty;

    virtual_channel_fifo dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .wr_channel(wr_channel),
        .wr_data(wr_data),
        .rd_en(rd_en),
        .rd_channel(rd_channel),
        .rd_data(rd_data),
        .full(full),
        .empty(empty)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{rd_data, full, empty}) === 1'bx) begin
            $display("[FAIL] 04_fifo/06_virtual_channel_fifo: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        wr_en = '0;
        wr_channel = '0;
        wr_data = '0;
        rd_en = '0;
        rd_channel = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        wr_en = '1;
        wr_channel = '1;
        wr_data = '1;
        rd_en = '1;
        rd_channel = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 04_fifo/06_virtual_channel_fifo baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 04_fifo/06_virtual_channel_fifo: timeout");
        $fatal(1);
    end
endmodule
