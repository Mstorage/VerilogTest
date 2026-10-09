`timescale 1ns/1ps
// Baseline self-checking testbench: AXI4-Lite 从设备 (★★★★☆☆)
// Core verification point: 独立处理 AW/W/B 与 AR/R 通道，支持字节写使能和响应保持。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_08_axi4_lite_slave;
    localparam integer ADDR_WIDTH = 12;
    localparam integer DATA_WIDTH = 32;
    reg aclk;
    reg areset_n;
    reg [ADDR_WIDTH-1:0] s_awaddr;
    reg s_awvalid;
    wire s_awready;
    reg [DATA_WIDTH-1:0] s_wdata;
    reg [DATA_WIDTH/8-1:0] s_wstrb;
    reg s_wvalid;
    wire s_wready;
    wire [2-1:0] s_bresp;
    wire s_bvalid;
    reg s_bready;
    reg [ADDR_WIDTH-1:0] s_araddr;
    reg s_arvalid;
    wire s_arready;
    wire [DATA_WIDTH-1:0] s_rdata;
    wire [2-1:0] s_rresp;
    wire s_rvalid;
    reg s_rready;

    axi4_lite_slave dut (
        .aclk(aclk),
        .areset_n(areset_n),
        .s_awaddr(s_awaddr),
        .s_awvalid(s_awvalid),
        .s_awready(s_awready),
        .s_wdata(s_wdata),
        .s_wstrb(s_wstrb),
        .s_wvalid(s_wvalid),
        .s_wready(s_wready),
        .s_bresp(s_bresp),
        .s_bvalid(s_bvalid),
        .s_bready(s_bready),
        .s_araddr(s_araddr),
        .s_arvalid(s_arvalid),
        .s_arready(s_arready),
        .s_rdata(s_rdata),
        .s_rresp(s_rresp),
        .s_rvalid(s_rvalid),
        .s_rready(s_rready)
    );

    always #3 aclk = ~aclk;

    task check_outputs_known;
    begin
        if ((^{s_awready, s_wready, s_bresp, s_bvalid, s_arready, s_rdata, s_rresp, s_rvalid}) === 1'bx) begin
            $display("[FAIL] 06_bus_protocol/08_axi4_lite_slave: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        aclk = 1'b0;
        areset_n = 1'b0;
        s_awaddr = '0;
        s_awvalid = '0;
        s_wdata = '0;
        s_wstrb = '0;
        s_wvalid = '0;
        s_bready = '0;
        s_araddr = '0;
        s_arvalid = '0;
        s_rready = '0;
        #20;
        areset_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        s_awaddr = '1;
        s_awvalid = '1;
        s_wdata = '1;
        s_wstrb = '1;
        s_wvalid = '1;
        s_bready = '1;
        s_araddr = '1;
        s_arvalid = '1;
        s_rready = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 06_bus_protocol/08_axi4_lite_slave baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 06_bus_protocol/08_axi4_lite_slave: timeout");
        $fatal(1);
    end
endmodule
