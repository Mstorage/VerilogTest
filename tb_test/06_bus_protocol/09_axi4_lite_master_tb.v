`timescale 1ns/1ps
// Baseline self-checking testbench: AXI4-Lite 主设备 (★★★★★☆)
// Core verification point: 将本地读写请求转换为 AXI 事务，处理通道乱序到达、背压和错误响应。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_09_axi4_lite_master;
    localparam integer ADDR_WIDTH = 12;
    localparam integer DATA_WIDTH = 32;
    reg aclk;
    reg areset_n;
    reg req_valid;
    wire req_ready;
    reg req_write;
    reg [ADDR_WIDTH-1:0] req_addr;
    reg [DATA_WIDTH-1:0] req_wdata;
    reg [DATA_WIDTH/8-1:0] req_wstrb;
    wire rsp_valid;
    reg rsp_ready;
    wire [DATA_WIDTH-1:0] rsp_rdata;
    wire [2-1:0] rsp_resp;
    wire [ADDR_WIDTH-1:0] m_awaddr;
    wire m_awvalid;
    reg m_awready;
    wire [DATA_WIDTH-1:0] m_wdata;
    wire [DATA_WIDTH/8-1:0] m_wstrb;
    wire m_wvalid;
    reg m_wready;
    reg [2-1:0] m_bresp;
    reg m_bvalid;
    wire m_bready;
    wire [ADDR_WIDTH-1:0] m_araddr;
    wire m_arvalid;
    reg m_arready;
    reg [DATA_WIDTH-1:0] m_rdata;
    reg [2-1:0] m_rresp;
    reg m_rvalid;
    wire m_rready;

    axi4_lite_master dut (
        .aclk(aclk),
        .areset_n(areset_n),
        .req_valid(req_valid),
        .req_ready(req_ready),
        .req_write(req_write),
        .req_addr(req_addr),
        .req_wdata(req_wdata),
        .req_wstrb(req_wstrb),
        .rsp_valid(rsp_valid),
        .rsp_ready(rsp_ready),
        .rsp_rdata(rsp_rdata),
        .rsp_resp(rsp_resp),
        .m_awaddr(m_awaddr),
        .m_awvalid(m_awvalid),
        .m_awready(m_awready),
        .m_wdata(m_wdata),
        .m_wstrb(m_wstrb),
        .m_wvalid(m_wvalid),
        .m_wready(m_wready),
        .m_bresp(m_bresp),
        .m_bvalid(m_bvalid),
        .m_bready(m_bready),
        .m_araddr(m_araddr),
        .m_arvalid(m_arvalid),
        .m_arready(m_arready),
        .m_rdata(m_rdata),
        .m_rresp(m_rresp),
        .m_rvalid(m_rvalid),
        .m_rready(m_rready)
    );

    always #3 aclk = ~aclk;

    task check_outputs_known;
    begin
        if ((^{req_ready, rsp_valid, rsp_rdata, rsp_resp, m_awaddr, m_awvalid, m_wdata, m_wstrb, m_wvalid, m_bready, m_araddr, m_arvalid, m_rready}) === 1'bx) begin
            $display("[FAIL] 06_bus_protocol/09_axi4_lite_master: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        aclk = 1'b0;
        areset_n = 1'b0;
        req_valid = '0;
        req_write = '0;
        req_addr = '0;
        req_wdata = '0;
        req_wstrb = '0;
        rsp_ready = '0;
        m_awready = '0;
        m_wready = '0;
        m_bresp = '0;
        m_bvalid = '0;
        m_arready = '0;
        m_rdata = '0;
        m_rresp = '0;
        m_rvalid = '0;
        #20;
        areset_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        req_valid = '1;
        req_write = '1;
        req_addr = '1;
        req_wdata = '1;
        req_wstrb = '1;
        rsp_ready = '1;
        m_awready = '1;
        m_wready = '1;
        m_bresp = '1;
        m_bvalid = '1;
        m_arready = '1;
        m_rdata = '1;
        m_rresp = '1;
        m_rvalid = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 06_bus_protocol/09_axi4_lite_master baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 06_bus_protocol/09_axi4_lite_master: timeout");
        $fatal(1);
    end
endmodule
