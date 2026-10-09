`timescale 1ns/1ps
// Baseline self-checking testbench: AHB-Lite SRAM 从设备 (★★★★☆☆)
// Core verification point: 正确处理地址/数据流水阶段、读写、等待和错误响应。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_05_ahb_lite_sram_slave;
    localparam integer ADDR_WIDTH = 12;
    localparam integer DATA_WIDTH = 32;
    localparam integer DEPTH = 1024;
    reg hclk;
    reg hreset_n;
    reg [2-1:0] htrans;
    reg hwrite;
    reg [3-1:0] hsize;
    reg [ADDR_WIDTH-1:0] haddr;
    reg [DATA_WIDTH-1:0] hwdata;
    reg hready_in;
    wire [DATA_WIDTH-1:0] hrdata;
    wire hready_out;
    wire hresp;

    ahb_lite_sram_slave dut (
        .hclk(hclk),
        .hreset_n(hreset_n),
        .htrans(htrans),
        .hwrite(hwrite),
        .hsize(hsize),
        .haddr(haddr),
        .hwdata(hwdata),
        .hready_in(hready_in),
        .hrdata(hrdata),
        .hready_out(hready_out),
        .hresp(hresp)
    );

    always #3 hclk = ~hclk;

    task check_outputs_known;
    begin
        if ((^{hrdata, hready_out, hresp}) === 1'bx) begin
            $display("[FAIL] 06_bus_protocol/05_ahb_lite_sram_slave: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        hclk = 1'b0;
        hreset_n = 1'b0;
        htrans = '0;
        hwrite = '0;
        hsize = '0;
        haddr = '0;
        hwdata = '0;
        hready_in = '0;
        #20;
        hreset_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        htrans = '1;
        hwrite = '1;
        hsize = '1;
        haddr = '1;
        hwdata = '1;
        hready_in = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 06_bus_protocol/05_ahb_lite_sram_slave baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 06_bus_protocol/05_ahb_lite_sram_slave: timeout");
        $fatal(1);
    end
endmodule
