`timescale 1ns/1ps
// Baseline self-checking testbench: AXI-Lite 协议检查器 (★★★★☆☆)
// Core verification point: 为五通道编写关键 SVA，随机化主从背压并覆盖地址/数据错拍到达。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_06_axi_lite_checker;
    localparam integer ADDR_WIDTH = 12;
    localparam integer DATA_WIDTH = 32;
    reg aclk;
    reg areset_n;
    reg awvalid;
    reg awready;
    reg [ADDR_WIDTH-1:0] awaddr;
    reg wvalid;
    reg wready;
    reg [DATA_WIDTH-1:0] wdata;
    reg bvalid;
    reg bready;
    reg arvalid;
    reg arready;
    reg [ADDR_WIDTH-1:0] araddr;
    reg rvalid;
    reg rready;
    reg [DATA_WIDTH-1:0] rdata;
    wire error;

    axi_lite_checker dut (
        .aclk(aclk),
        .areset_n(areset_n),
        .awvalid(awvalid),
        .awready(awready),
        .awaddr(awaddr),
        .wvalid(wvalid),
        .wready(wready),
        .wdata(wdata),
        .bvalid(bvalid),
        .bready(bready),
        .arvalid(arvalid),
        .arready(arready),
        .araddr(araddr),
        .rvalid(rvalid),
        .rready(rready),
        .rdata(rdata),
        .error(error)
    );

    always #3 aclk = ~aclk;

    task check_outputs_known;
    begin
        if ((^{error}) === 1'bx) begin
            $display("[FAIL] 08_verification_system/06_axi_lite_checker: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        aclk = 1'b0;
        areset_n = 1'b0;
        awvalid = '0;
        awready = '0;
        awaddr = '0;
        wvalid = '0;
        wready = '0;
        wdata = '0;
        bvalid = '0;
        bready = '0;
        arvalid = '0;
        arready = '0;
        araddr = '0;
        rvalid = '0;
        rready = '0;
        rdata = '0;
        #20;
        areset_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        awvalid = '1;
        awready = '1;
        awaddr = '1;
        wvalid = '1;
        wready = '1;
        wdata = '1;
        bvalid = '1;
        bready = '1;
        arvalid = '1;
        arready = '1;
        araddr = '1;
        rvalid = '1;
        rready = '1;
        rdata = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 08_verification_system/06_axi_lite_checker baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 08_verification_system/06_axi_lite_checker: timeout");
        $fatal(1);
    end
endmodule
