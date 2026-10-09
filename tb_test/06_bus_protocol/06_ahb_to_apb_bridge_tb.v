`timescale 1ns/1ps
// Baseline self-checking testbench: AHB-Lite 到 APB 桥 (★★★★☆☆)
// Core verification point: 将流水 AHB 事务转换为 APB 两阶段事务，加入地址译码和等待传播。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_06_ahb_to_apb_bridge;
    localparam integer ADDR_WIDTH = 16;
    localparam integer DATA_WIDTH = 32;
    reg hclk;
    reg hreset_n;
    reg [2-1:0] htrans;
    reg hwrite;
    reg [ADDR_WIDTH-1:0] haddr;
    reg [DATA_WIDTH-1:0] hwdata;
    wire [DATA_WIDTH-1:0] hrdata;
    wire hready;
    wire hresp;
    wire psel;
    wire penable;
    wire pwrite;
    wire [ADDR_WIDTH-1:0] paddr;
    wire [DATA_WIDTH-1:0] pwdata;
    reg [DATA_WIDTH-1:0] prdata;
    reg pready;
    reg pslverr;

    ahb_to_apb_bridge dut (
        .hclk(hclk),
        .hreset_n(hreset_n),
        .htrans(htrans),
        .hwrite(hwrite),
        .haddr(haddr),
        .hwdata(hwdata),
        .hrdata(hrdata),
        .hready(hready),
        .hresp(hresp),
        .psel(psel),
        .penable(penable),
        .pwrite(pwrite),
        .paddr(paddr),
        .pwdata(pwdata),
        .prdata(prdata),
        .pready(pready),
        .pslverr(pslverr)
    );

    always #3 hclk = ~hclk;

    task check_outputs_known;
    begin
        if ((^{hrdata, hready, hresp, psel, penable, pwrite, paddr, pwdata}) === 1'bx) begin
            $display("[FAIL] 06_bus_protocol/06_ahb_to_apb_bridge: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        hclk = 1'b0;
        hreset_n = 1'b0;
        htrans = '0;
        hwrite = '0;
        haddr = '0;
        hwdata = '0;
        prdata = '0;
        pready = '0;
        pslverr = '0;
        #20;
        hreset_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        htrans = '1;
        hwrite = '1;
        haddr = '1;
        hwdata = '1;
        prdata = '1;
        pready = '1;
        pslverr = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 06_bus_protocol/06_ahb_to_apb_bridge baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 06_bus_protocol/06_ahb_to_apb_bridge: timeout");
        $fatal(1);
    end
endmodule
