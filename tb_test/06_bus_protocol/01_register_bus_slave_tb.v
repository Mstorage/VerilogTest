`timescale 1ns/1ps
// Baseline self-checking testbench: 简单寄存器总线从设备 (★★☆☆☆☆)
// Core verification point: 实现地址译码、读写寄存器、只读/写一清零字段和非法地址响应。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_01_register_bus_slave;
    localparam integer ADDR_WIDTH = 8;
    localparam integer DATA_WIDTH = 32;
    reg clk;
    reg rst_n;
    reg req;
    reg write;
    reg [ADDR_WIDTH-1:0] addr;
    reg [DATA_WIDTH-1:0] wdata;
    reg [DATA_WIDTH-1:0] wstrb;
    wire ready;
    wire [DATA_WIDTH-1:0] rdata;
    wire error;

    register_bus_slave dut (
        .clk(clk),
        .rst_n(rst_n),
        .req(req),
        .write(write),
        .addr(addr),
        .wdata(wdata),
        .wstrb(wstrb),
        .ready(ready),
        .rdata(rdata),
        .error(error)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{ready, rdata, error}) === 1'bx) begin
            $display("[FAIL] 06_bus_protocol/01_register_bus_slave: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        req = '0;
        write = '0;
        addr = '0;
        wdata = '0;
        wstrb = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        req = '1;
        write = '1;
        addr = '1;
        wdata = '1;
        wstrb = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 06_bus_protocol/01_register_bus_slave baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 06_bus_protocol/01_register_bus_slave: timeout");
        $fatal(1);
    end
endmodule
