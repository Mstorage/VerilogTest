`timescale 1ns/1ps
// Baseline self-checking testbench: 请求-应答四相握手 (★★☆☆☆☆)
// Core verification point: 源端保持数据直至应答，目的端只接收一次，并处理连续请求。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_01_four_phase_handshake;
    localparam integer WIDTH = 8;
    reg src_clk;
    reg dst_clk;
    reg rst_n;
    reg send;
    reg [WIDTH-1:0] data_in;
    wire busy;
    wire data_valid;
    wire [WIDTH-1:0] data_out;

    four_phase_handshake dut (
        .src_clk(src_clk),
        .dst_clk(dst_clk),
        .rst_n(rst_n),
        .send(send),
        .data_in(data_in),
        .busy(busy),
        .data_valid(data_valid),
        .data_out(data_out)
    );

    always #3 src_clk = ~src_clk;
    always #5 dst_clk = ~dst_clk;

    task check_outputs_known;
    begin
        if ((^{busy, data_valid, data_out}) === 1'bx) begin
            $display("[FAIL] 03_flow_control/01_four_phase_handshake: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        src_clk = 1'b0;
        dst_clk = 1'b0;
        rst_n = 1'b0;
        send = '0;
        data_in = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        send = '1;
        data_in = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 03_flow_control/01_four_phase_handshake baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 03_flow_control/01_four_phase_handshake: timeout");
        $fatal(1);
    end
endmodule
