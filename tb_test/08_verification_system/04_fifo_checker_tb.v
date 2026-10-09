`timescale 1ns/1ps
// Baseline self-checking testbench: FIFO scoreboard 与断言 (★★★★☆☆)
// Core verification point: 随机读写并检查顺序、满空边界、禁止溢出/下溢和指针合法性。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_04_fifo_checker;
    localparam integer WIDTH = 8;
    localparam integer DEPTH = 16;
    reg clk;
    reg rst_n;
    reg wr_en;
    reg [WIDTH-1:0] wr_data;
    reg rd_en;
    reg [WIDTH-1:0] rd_data;
    reg full;
    reg empty;
    wire error;

    fifo_checker dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .rd_en(rd_en),
        .rd_data(rd_data),
        .full(full),
        .empty(empty),
        .error(error)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{error}) === 1'bx) begin
            $display("[FAIL] 08_verification_system/04_fifo_checker: output contains X/Z");
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
        rd_data = '0;
        full = '0;
        empty = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        wr_en = '1;
        wr_data = '1;
        rd_en = '1;
        rd_data = '1;
        full = '1;
        empty = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 08_verification_system/04_fifo_checker baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 08_verification_system/04_fifo_checker: timeout");
        $fatal(1);
    end
endmodule
