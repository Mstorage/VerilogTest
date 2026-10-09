`timescale 1ns/1ps
// 测试契约：对同步输入产生逐位、单周期（时钟对齐、寄存器输出）rise/fall/any_edge 脉冲；
// 低有效异步复位清除历史值与脉冲输出。
// 覆盖：
//   1. 定向：多位上升/下降、同一拍升降并存、无变化时脉冲清零（单周期）；
//   2. 复位期间（din 任意）脉冲输出必须为 0；复位释放后高电平重新算作上升沿；
//   3. 负边沿稳定性：din 变化后、正边沿采样前，输出必须保持上一拍值
//      （检出组合逻辑型“边沿检测”实现）；
//   4. 随机序列（200 拍）与黄金模型比对，随机插入异步复位；
//   5. WIDTH=1 参数化实例。
module tb_06_edge_detector;
    localparam integer WIDTH = 8;
    reg clk, rst_n;
    reg [WIDTH-1:0] din;
    wire [WIDTH-1:0] rise, fall, any_edge;
    reg [WIDTH-1:0] previous, prev_rise, prev_fall;
    integer errors, i, seed;

    edge_detector #(.WIDTH(WIDTH)) dut (
        .clk(clk), .rst_n(rst_n), .din(din),
        .rise(rise), .fall(fall), .any_edge(any_edge)
    );
    always #5 clk = ~clk;

    // WIDTH=1 参数化实例（共享 clk/rst_n）。
    reg din1;
    wire rise1, fall1, any1;
    edge_detector #(.WIDTH(1)) dut1 (
        .clk(clk), .rst_n(rst_n), .din(din1),
        .rise(rise1), .fall(fall1), .any_edge(any1)
    );

    // 一拍驱动+检查：先验证负边沿稳定性，再在正边沿后比对期望脉冲。
    task step;
        input [WIDTH-1:0] next_value;
        reg [WIDTH-1:0] expected_rise, expected_fall;
        begin
            @(negedge clk);
            din = next_value;
            #1;
            // 输出是寄存器的：din 变化后、正边沿采样前必须保持上一拍的值。
            if (rise !== prev_rise || fall !== prev_fall ||
                any_edge !== (prev_rise | prev_fall)) begin
                $display("[ERROR] outputs changed before posedge (combinational edge detect?)");
                errors = errors + 1;
            end
            @(posedge clk); #1;
            expected_rise = next_value & ~previous;
            expected_fall = ~next_value & previous;
            if (rise !== expected_rise || fall !== expected_fall ||
                any_edge !== (expected_rise | expected_fall)) begin
                $display("[ERROR] prev=%b din=%b exp rise/fall=%b/%b got=%b/%b any=%b",
                         previous, next_value, expected_rise, expected_fall, rise, fall, any_edge);
                errors = errors + 1;
            end
            previous = next_value;
            prev_rise = expected_rise;
            prev_fall = expected_fall;
        end
    endtask

    initial begin
        errors = 0; seed = 32'hED6E_0006;
        clk = 0; rst_n = 0; din = 0; din1 = 0;
        previous = 0; prev_rise = 0; prev_fall = 0;
        #2;
        if (rise !== 0 || fall !== 0 || any_edge !== 0) begin
            $display("[ERROR] outputs not cleared by asynchronous reset"); errors = errors + 1;
        end
        @(negedge clk); rst_n = 1;

        step(8'b0000_0000);
        step(8'b0001_0101); // 多位上升沿
        step(8'b0011_0001); // 同一拍既有上升也有下降
        step(8'b0011_0001); // 无变化，脉冲必须清零（单周期）
        step(8'b0000_0000); // 多位下降沿
        step(8'b1111_1111);

        // 异步复位还必须清除历史值，释放后高电平应重新算作上升沿。
        @(negedge clk); #2; rst_n = 0; #1;   // din 仍为上一拍的 1111_1111
        if (rise !== 0 || fall !== 0 || any_edge !== 0) begin
            $display("[ERROR] async reset did not clear pulse outputs"); errors = errors + 1;
        end
        // 释放复位前把 din 归零：避免释放后的第一个 posedge 把旧值误判为上升沿，
        // 使模型（previous=0）与 DUT 状态保持同步。
        din = 0;
        previous = 0; prev_rise = 0; prev_fall = 0; rst_n = 1;
        step(8'b1000_0001);

        // 随机序列 + 黄金模型，随机插入复位（复位期间 din 任意，脉冲必须为 0）。
        for (i = 0; i < 200; i = i + 1) begin
            if (($random(seed) & 32'h3F) == 0) begin
                @(negedge clk); rst_n = 0; #1;
                if (rise !== 0 || fall !== 0 || any_edge !== 0) begin
                    $display("[ERROR] random reset: pulses not cleared (din=%b)", din);
                    errors = errors + 1;
                end
                din = 0;   // 见上：复位期间归零，保证与模型同步
                previous = 0; prev_rise = 0; prev_fall = 0;
                rst_n = 1;
            end
            step($random(seed));
        end

        // WIDTH=1 实例定向检查。
        rst_n = 0; #1;
        if (rise1 !== 0 || fall1 !== 0 || any1 !== 0) begin
            $display("[ERROR] W1 reset"); errors = errors + 1;
        end
        rst_n = 1;
        @(negedge clk); din1 = 1'b1;
        @(posedge clk); #1;
        if (rise1 !== 1'b1 || fall1 !== 1'b0 || any1 !== 1'b1) begin
            $display("[ERROR] W1 rising edge"); errors = errors + 1;
        end
        @(negedge clk); din1 = 1'b1;
        @(posedge clk); #1;
        if (rise1 !== 1'b0 || fall1 !== 1'b0 || any1 !== 1'b0) begin
            $display("[ERROR] W1 no-change pulse not one-cycle"); errors = errors + 1;
        end
        @(negedge clk); din1 = 1'b0;
        @(posedge clk); #1;
        if (rise1 !== 1'b0 || fall1 !== 1'b1 || any1 !== 1'b1) begin
            $display("[ERROR] W1 falling edge"); errors = errors + 1;
        end

        if (errors == 0) $display("[PASS] per-bit edge detection, random + reset-in-stream + WIDTH=1");
        else begin $display("[FAIL] edge_detector: %0d error(s)", errors); $fatal(1); end
        $finish;
    end
endmodule
