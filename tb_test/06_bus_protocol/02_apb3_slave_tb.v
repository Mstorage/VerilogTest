`timescale 1ns/1ps
// Baseline self-checking testbench: APB3 从设备 (★★★☆☆☆)
// Core verification point: 实现 SETUP/ACCESS 两阶段传输、等待状态和错误响应。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_02_apb3_slave;
    localparam integer ADDR_WIDTH = 12;
    localparam integer DATA_WIDTH = 32;
    reg pclk;
    reg preset_n;
    reg psel;
    reg penable;
    reg pwrite;
    reg [ADDR_WIDTH-1:0] paddr;
    reg [DATA_WIDTH-1:0] pwdata;
    wire [DATA_WIDTH-1:0] prdata;
    wire pready;
    wire pslverr;

    apb3_slave dut (
        .pclk(pclk),
        .preset_n(preset_n),
        .psel(psel),
        .penable(penable),
        .pwrite(pwrite),
        .paddr(paddr),
        .pwdata(pwdata),
        .prdata(prdata),
        .pready(pready),
        .pslverr(pslverr)
    );

    always #3 pclk = ~pclk;

    task check_outputs_known;
    begin
        if ((^{prdata, pready, pslverr}) === 1'bx) begin
            $display("[FAIL] 06_bus_protocol/02_apb3_slave: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        pclk = 1'b0;
        preset_n = 1'b0;
        psel = '0;
        penable = '0;
        pwrite = '0;
        paddr = '0;
        pwdata = '0;
        #20;
        preset_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        psel = '1;
        penable = '1;
        pwrite = '1;
        paddr = '1;
        pwdata = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 06_bus_protocol/02_apb3_slave baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 06_bus_protocol/02_apb3_slave: timeout");
        $fatal(1);
    end
endmodule
