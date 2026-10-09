`timescale 1ns/1ps
// Baseline self-checking testbench: 工程化异步 FIFO (★★★★★★)
// Core verification point: 加入可配深度、almost 标志、复位恢复、随机异频验证与 CDC/断言检查。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_08_async_fifo_engineering;
    localparam integer WIDTH = 8;
    localparam integer DEPTH = 16;
    localparam integer ADDR_WIDTH = 4;
    localparam integer ALMOST_MARGIN = 2;
    reg wclk;
    reg wrst_n;
    reg w_en;
    reg [WIDTH-1:0] w_data;
    wire w_full;
    wire w_almost_full;
    reg rclk;
    reg rrst_n;
    reg r_en;
    wire [WIDTH-1:0] r_data;
    wire r_empty;
    wire r_almost_empty;

    async_fifo_engineering dut (
        .wclk(wclk),
        .wrst_n(wrst_n),
        .w_en(w_en),
        .w_data(w_data),
        .w_full(w_full),
        .w_almost_full(w_almost_full),
        .rclk(rclk),
        .rrst_n(rrst_n),
        .r_en(r_en),
        .r_data(r_data),
        .r_empty(r_empty),
        .r_almost_empty(r_almost_empty)
    );

    always #3 wclk = ~wclk;
    always #5 rclk = ~rclk;

    task check_outputs_known;
    begin
        if ((^{w_full, w_almost_full, r_data, r_empty, r_almost_empty}) === 1'bx) begin
            $display("[FAIL] 04_fifo/08_async_fifo_engineering: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        wclk = 1'b0;
        wrst_n = 1'b0;
        w_en = '0;
        w_data = '0;
        rclk = 1'b0;
        rrst_n = 1'b0;
        r_en = '0;
        #20;
        wrst_n = 1'b1;
        rrst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        w_en = '1;
        w_data = '1;
        r_en = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 04_fifo/08_async_fifo_engineering baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 04_fifo/08_async_fifo_engineering: timeout");
        $fatal(1);
    end
endmodule
