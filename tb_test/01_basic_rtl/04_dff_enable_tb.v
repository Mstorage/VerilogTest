`timescale 1ns/1ps
// 测试契约：低有效异步复位，上升沿采样，优先级 reset > enable > hold。
// 覆盖：
//   1. 定向：异步复位、使能捕获、多拍保持、复位优先级、复位释放后恢复捕获；
//   2. posedge 前 1ns 拉低复位：本拍不得捕获，且整拍保持 0（区分同步复位）；
//   3. 负边沿稳定性：posedge 捕获后、周期后半段改 d，q 不得变化；
//   4. 随机序列（200 拍）：随机 d/en + 随机异步复位，与黄金模型比对；
//   5. WIDTH=1 参数化实例。
module tb_04_dff_enable;
    localparam integer WIDTH = 8;
    reg clk, rst_n, en;
    reg [WIDTH-1:0] d;
    wire [WIDTH-1:0] q;
    reg [WIDTH-1:0] model_q;
    integer errors, i, seed;

    dff_enable #(.WIDTH(WIDTH)) dut (.clk(clk), .rst_n(rst_n), .en(en), .d(d), .q(q));
    always #5 clk = ~clk;

    // WIDTH=1 参数化实例（与主实例共享 clk/rst_n，顺序执行无冲突）。
    reg en1, d1;
    wire q1;
    dff_enable #(.WIDTH(1)) dut1 (.clk(clk), .rst_n(rst_n), .en(en1), .d(d1), .q(q1));

    task expect_q;
        input [WIDTH-1:0] expected;
        input [8*48-1:0] label_text;
        begin
            #1;
            if (q !== expected) begin
                $display("[ERROR] %0s expected=%h actual=%h", label_text, expected, q);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0; seed = 32'hD0FF_0004;
        clk = 0; rst_n = 0; en = 0; d = 8'hA5; en1 = 0; d1 = 0;
        #2; expect_q(8'h00, "initial async reset");

        rst_n = 1;
        en = 1; d = 8'h12;
        @(posedge clk); expect_q(8'h12, "enabled capture");

        en = 0; d = 8'h34;
        @(posedge clk); expect_q(8'h12, "hold while disabled");
        @(posedge clk); expect_q(8'h12, "multi-cycle hold");

        en = 1; d = 8'hFE;
        @(posedge clk); expect_q(8'hFE, "second capture");

        // 在两个时钟沿之间拉低，必须立即复位（异步而非同步复位）。
        @(negedge clk); #2; rst_n = 0;
        expect_q(8'h00, "asynchronous reset between edges");
        d = 8'h77; en = 1;
        @(posedge clk); expect_q(8'h00, "reset priority over enable");

        rst_n = 1;
        @(posedge clk); expect_q(8'h77, "capture after reset release");

        // posedge 前 1ns 拉低复位：本拍必须不捕获，且整拍保持 0。
        @(negedge clk); #4; rst_n = 0; en = 1; d = 8'hFF;
        #1; expect_q(8'h00, "reset just before posedge");
        @(negedge clk); expect_q(8'h00, "held through edge cycle");
        rst_n = 1;

        // 负边沿稳定性：posedge 捕获后，周期后半段改 d，q 在 negedge 前不得变化。
        en = 1; d = 8'h5A;
        @(posedge clk); expect_q(8'h5A, "pre-capture for negedge check");
        #3; d = 8'hC3;   // posedge 后 3ns（正半段）改 d
        #2;             // 越过 negedge
        if (q !== 8'h5A) begin
            $display("[ERROR] q changed during negative half-cycle (not a posedge register)");
            errors = errors + 1;
        end
        en = 0; // 防止下一拍误捕获

        // 随机序列 + 黄金模型。
        @(negedge clk); rst_n = 0; #1; model_q = 0; rst_n = 1;
        for (i = 0; i < 200; i = i + 1) begin
            @(negedge clk);
            en = $random(seed) & 1'b1;
            d  = $random(seed);
            if (($random(seed) & 32'h0F) == 0) begin
                rst_n = 0; #1;
                model_q = 0;
                if (q !== model_q) begin
                    $display("[ERROR] random async reset expected=%h actual=%h", model_q, q);
                    errors = errors + 1;
                end
                rst_n = 1;
            end
            @(posedge clk); #1;
            if (en) model_q = d;
            if (q !== model_q) begin
                $display("[ERROR] random step en=%b d=%h expected=%h actual=%h", en, d, model_q, q);
                errors = errors + 1;
            end
        end

        // WIDTH=1 实例定向检查。
        rst_n = 0; #1;
        if (q1 !== 1'b0) begin $display("[ERROR] W1 reset"); errors = errors + 1; end
        rst_n = 1;
        en1 = 1; d1 = 1'b1;
        @(posedge clk); #1; if (q1 !== 1'b1) begin $display("[ERROR] W1 capture 1"); errors = errors + 1; end
        en1 = 0; d1 = 1'b0;
        @(posedge clk); #1; if (q1 !== 1'b1) begin $display("[ERROR] W1 hold"); errors = errors + 1; end
        en1 = 1; d1 = 1'b0;
        @(posedge clk); #1; if (q1 !== 1'b0) begin $display("[ERROR] W1 capture 0"); errors = errors + 1; end

        if (errors == 0) $display("[PASS] DFF reset/enable/hold priority, random + WIDTH=1");
        else begin $display("[FAIL] dff_enable: %0d error(s)", errors); $fatal(1); end
        $finish;
    end
endmodule
