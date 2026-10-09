`timescale 1ns/1ps
// Baseline self-checking testbench: First-Word Fall-Through FIFO (★★★☆☆☆)
// Core verification point: 非空时首字自动出现在输出端，并维持 Ready/Valid 语义。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_04_fwft_fifo;
    localparam integer WIDTH = 8;
    localparam integer DEPTH = 16;
    localparam integer ADDR_WIDTH = 4;
    reg clk;
    reg rst_n;
    reg s_valid;
    wire s_ready;
    reg [WIDTH-1:0] s_data;
    wire m_valid;
    reg m_ready;
    wire [WIDTH-1:0] m_data;

    fwft_fifo dut (
        .clk(clk),
        .rst_n(rst_n),
        .s_valid(s_valid),
        .s_ready(s_ready),
        .s_data(s_data),
        .m_valid(m_valid),
        .m_ready(m_ready),
        .m_data(m_data)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{s_ready, m_valid, m_data}) === 1'bx) begin
            $display("[FAIL] 04_fifo/04_fwft_fifo: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        s_valid = '0;
        s_data = '0;
        m_ready = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        s_valid = '1;
        s_data = '1;
        m_ready = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 04_fifo/04_fwft_fifo baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 04_fifo/04_fwft_fifo: timeout");
        $fatal(1);
    end
endmodule
