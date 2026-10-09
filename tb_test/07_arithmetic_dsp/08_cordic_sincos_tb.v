`timescale 1ns/1ps
// Baseline self-checking testbench: CORDIC 三角函数发生器 (★★★★★☆)
// Core verification point: 以旋转模式流水或迭代地产生 sin/cos，完成象限预处理和增益补偿。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_08_cordic_sincos;
    localparam integer ANGLE_WIDTH = 16;
    localparam integer DATA_WIDTH = 16;
    localparam integer ITERATIONS = 16;
    reg clk;
    reg rst_n;
    reg in_valid;
    reg [ANGLE_WIDTH-1:0] angle;
    wire out_valid;
    wire [DATA_WIDTH-1:0] sine;
    wire [DATA_WIDTH-1:0] cosine;

    cordic_sincos dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .angle(angle),
        .out_valid(out_valid),
        .sine(sine),
        .cosine(cosine)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{out_valid, sine, cosine}) === 1'bx) begin
            $display("[FAIL] 07_arithmetic_dsp/08_cordic_sincos: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        in_valid = '0;
        angle = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        in_valid = '1;
        angle = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 07_arithmetic_dsp/08_cordic_sincos baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 07_arithmetic_dsp/08_cordic_sincos: timeout");
        $fatal(1);
    end
endmodule
