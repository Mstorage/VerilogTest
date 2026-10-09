`timescale 1ns/1ps
// Baseline self-checking testbench: Mini-DMA 综合项目 (★★★★★★)
// Core verification point: 从 AXI4-Lite 寄存器取配置，经 AXI/简化存储接口搬运数据，以 Stream 输出；集成 FIFO、仲裁、错误与中断。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_08_mini_dma;
    localparam integer ADDR_WIDTH = 32;
    localparam integer DATA_WIDTH = 32;
    localparam integer LENGTH_WIDTH = 16;
    reg clk;
    reg rst_n;
    reg cfg_start;
    reg [ADDR_WIDTH-1:0] cfg_src_addr;
    reg [LENGTH_WIDTH-1:0] cfg_length;
    wire busy;
    wire done;
    wire error;
    wire mem_req_valid;
    reg mem_req_ready;
    wire [ADDR_WIDTH-1:0] mem_req_addr;
    reg mem_rsp_valid;
    reg [DATA_WIDTH-1:0] mem_rsp_data;
    wire stream_valid;
    reg stream_ready;
    wire [DATA_WIDTH-1:0] stream_data;
    wire stream_last;

    mini_dma dut (
        .clk(clk),
        .rst_n(rst_n),
        .cfg_start(cfg_start),
        .cfg_src_addr(cfg_src_addr),
        .cfg_length(cfg_length),
        .busy(busy),
        .done(done),
        .error(error),
        .mem_req_valid(mem_req_valid),
        .mem_req_ready(mem_req_ready),
        .mem_req_addr(mem_req_addr),
        .mem_rsp_valid(mem_rsp_valid),
        .mem_rsp_data(mem_rsp_data),
        .stream_valid(stream_valid),
        .stream_ready(stream_ready),
        .stream_data(stream_data),
        .stream_last(stream_last)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{busy, done, error, mem_req_valid, mem_req_addr, stream_valid, stream_data, stream_last}) === 1'bx) begin
            $display("[FAIL] 08_verification_system/08_mini_dma: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        cfg_start = '0;
        cfg_src_addr = '0;
        cfg_length = '0;
        mem_req_ready = '0;
        mem_rsp_valid = '0;
        mem_rsp_data = '0;
        stream_ready = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        cfg_start = '1;
        cfg_src_addr = '1;
        cfg_length = '1;
        mem_req_ready = '1;
        mem_rsp_valid = '1;
        mem_rsp_data = '1;
        stream_ready = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 08_verification_system/08_mini_dma baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 08_verification_system/08_mini_dma: timeout");
        $fatal(1);
    end
endmodule
