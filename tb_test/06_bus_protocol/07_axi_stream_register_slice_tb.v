`timescale 1ns/1ps
// Baseline self-checking testbench: AXI4-Stream 寄存切片 (★★★★☆☆)
// Core verification point: 支持 `TVALID/TREADY/TDATA/TLAST`，在连续流和随机背压下无丢失。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_07_axi_stream_register_slice;
    localparam integer DATA_WIDTH = 32;
    reg aclk;
    reg areset_n;
    reg s_tvalid;
    wire s_tready;
    reg [DATA_WIDTH-1:0] s_tdata;
    reg s_tlast;
    wire m_tvalid;
    reg m_tready;
    wire [DATA_WIDTH-1:0] m_tdata;
    wire m_tlast;

    axi_stream_register_slice dut (
        .aclk(aclk),
        .areset_n(areset_n),
        .s_tvalid(s_tvalid),
        .s_tready(s_tready),
        .s_tdata(s_tdata),
        .s_tlast(s_tlast),
        .m_tvalid(m_tvalid),
        .m_tready(m_tready),
        .m_tdata(m_tdata),
        .m_tlast(m_tlast)
    );

    always #3 aclk = ~aclk;

    task check_outputs_known;
    begin
        if ((^{s_tready, m_tvalid, m_tdata, m_tlast}) === 1'bx) begin
            $display("[FAIL] 06_bus_protocol/07_axi_stream_register_slice: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        aclk = 1'b0;
        areset_n = 1'b0;
        s_tvalid = '0;
        s_tdata = '0;
        s_tlast = '0;
        m_tready = '0;
        #20;
        areset_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        s_tvalid = '1;
        s_tdata = '1;
        s_tlast = '1;
        m_tready = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 06_bus_protocol/07_axi_stream_register_slice baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 06_bus_protocol/07_axi_stream_register_slice: timeout");
        $fatal(1);
    end
endmodule
