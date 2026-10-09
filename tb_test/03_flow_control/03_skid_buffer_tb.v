`timescale 1ns/1ps
// Baseline self-checking testbench: Skid Buffer (★★★☆☆☆)
// Core verification point: 构造一拍弹性缓存，切断组合 ready 路径且不丢数、不重数。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_03_skid_buffer;
    localparam integer WIDTH = 8;
    reg clk;
    reg rst_n;
    reg s_valid;
    wire s_ready;
    reg [WIDTH-1:0] s_data;
    wire m_valid;
    reg m_ready;
    wire [WIDTH-1:0] m_data;

    skid_buffer dut (
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
            $display("[FAIL] 03_flow_control/03_skid_buffer: output contains X/Z");
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

        $display("[PASS] 03_flow_control/03_skid_buffer baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 03_flow_control/03_skid_buffer: timeout");
        $fatal(1);
    end
endmodule
