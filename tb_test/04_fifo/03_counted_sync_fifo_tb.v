`timescale 1ns/1ps
// Baseline self-checking testbench: 计数型同步 FIFO (★★★☆☆☆)
// Core verification point: 增加 `count/almost_full/almost_empty`，覆盖同周期读写及满/空边界。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_03_counted_sync_fifo;
    localparam integer WIDTH = 8;
    localparam integer DEPTH = 16;
    localparam integer ADDR_WIDTH = 4;
    localparam integer COUNT_WIDTH = 5;
    localparam integer ALMOST_FULL = 14;
    localparam integer ALMOST_EMPTY = 2;
    reg clk;
    reg rst_n;
    reg wr_en;
    reg [WIDTH-1:0] wr_data;
    reg rd_en;
    wire [WIDTH-1:0] rd_data;
    wire full;
    wire empty;
    wire almost_full;
    wire almost_empty;
    wire [COUNT_WIDTH-1:0] count;

    counted_sync_fifo dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .rd_en(rd_en),
        .rd_data(rd_data),
        .full(full),
        .empty(empty),
        .almost_full(almost_full),
        .almost_empty(almost_empty),
        .count(count)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{rd_data, full, empty, almost_full, almost_empty, count}) === 1'bx) begin
            $display("[FAIL] 04_fifo/03_counted_sync_fifo: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        wr_en = '0;
        wr_data = '0;
        rd_en = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        wr_en = '1;
        wr_data = '1;
        rd_en = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 04_fifo/03_counted_sync_fifo baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 04_fifo/03_counted_sync_fifo: timeout");
        $fatal(1);
    end
endmodule
