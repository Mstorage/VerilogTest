`timescale 1ns/1ps
// 测试契约：reset > load > en；dir=0 左移、dir=1 右移；串行输入移入正确一侧。
// 覆盖：
//   1. 定向：并行装载优先级、保持、左右移、重新装载、复位；
//   2. 负边沿稳定性：激励在负边沿变化，正边沿采样前 q 不得变化；
//   3. 随机序列（300 拍）与黄金模型比对，随机插入异步复位；
//   4. WIDTH=1 参数化实例。
module tb_07_shift_register;
    localparam integer WIDTH = 8;
    reg clk, rst_n, load, dir, en, serial_in;
    reg [WIDTH-1:0] pdata;
    wire [WIDTH-1:0] q;
    reg [WIDTH-1:0] model_q;
    integer errors, i, seed;

    shift_register #(.WIDTH(WIDTH)) dut (
        .clk(clk), .rst_n(rst_n), .load(load), .dir(dir), .en(en),
        .pdata(pdata), .serial_in(serial_in), .q(q)
    );
    always #5 clk = ~clk;

    // WIDTH=1 参数化实例（共享 clk/rst_n）。
    reg load1, dir1, en1, serial1;
    reg pdata1;
    wire q1;
    shift_register #(.WIDTH(1)) dut1 (
        .clk(clk), .rst_n(rst_n), .load(load1), .dir(dir1), .en(en1),
        .pdata(pdata1), .serial_in(serial1), .q(q1)
    );

    task clock_and_check;
        input [WIDTH-1:0] expected;
        input [8*40-1:0] label_text;
        begin
            @(posedge clk); #1;
            if (q !== expected) begin
                $display("[ERROR] %0s expected=%b actual=%b", label_text, expected, q);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0; seed = 32'h5EAF_0007;
        clk = 0; rst_n = 0; load = 0; dir = 0; en = 0;
        serial_in = 0; pdata = 0; load1 = 0; dir1 = 0; en1 = 0; serial1 = 0; pdata1 = 0;
        #2; if (q !== 0) begin $display("[ERROR] async reset"); errors = errors + 1; end
        @(negedge clk); rst_n = 1;

        // load 与 en 同时有效，load 必须优先。
        load = 1; en = 1; pdata = 8'b1010_0101; serial_in = 1;
        clock_and_check(8'b1010_0101, "parallel load priority");

        load = 0; en = 0; pdata = 8'hFF;
        clock_and_check(8'b1010_0101, "hold");

        en = 1; dir = 0; serial_in = 1;
        clock_and_check(8'b0100_1011, "left shift one");
        serial_in = 0;
        clock_and_check(8'b1001_0110, "left shift two");

        load = 1; pdata = 8'b1000_0001;
        clock_and_check(8'b1000_0001, "reload");
        load = 0; dir = 1; serial_in = 1;
        clock_and_check(8'b1100_0000, "right shift one");
        serial_in = 0;
        clock_and_check(8'b0110_0000, "right shift two");

        // 随机序列 + 黄金模型。
        @(negedge clk); rst_n = 0; #1; model_q = 0; rst_n = 1;
        for (i = 0; i < 300; i = i + 1) begin
            @(negedge clk);
            load      = $random(seed) & 1'b1;
            dir       = $random(seed) & 1'b1;
            en        = $random(seed) & 1'b1;
            serial_in = $random(seed) & 1'b1;
            pdata     = $random(seed);
            if (($random(seed) & 32'h1F) == 0) begin
                rst_n = 0; #1;
                model_q = 0;
                if (q !== model_q) begin
                    $display("[ERROR] random reset expected=%h actual=%h", model_q, q);
                    errors = errors + 1;
                end
                rst_n = 1;
            end
            #1;
            if (q !== model_q) begin
                $display("[ERROR] q changed before posedge (expected=%h actual=%h)", model_q, q);
                errors = errors + 1;
            end
            @(posedge clk); #1;
            if (load) model_q = pdata;
            else if (en) begin
                if (dir) model_q = {serial_in, model_q[WIDTH-1:1]};
                else     model_q = {model_q[WIDTH-2:0], serial_in};
            end
            if (q !== model_q) begin
                $display("[ERROR] random load/dir/en/si=%b/%b/%b/%b pdata=%h expected=%h actual=%h",
                         load, dir, en, serial_in, pdata, model_q, q);
                errors = errors + 1;
            end
        end

        // WIDTH=1 实例。
        @(negedge clk); rst_n = 0; #1;
        if (q1 !== 1'b0) begin $display("[ERROR] W1 reset"); errors = errors + 1; end
        rst_n = 1;
        load1 = 1; en1 = 0; pdata1 = 1'b1;
        @(posedge clk); #1; if (q1 !== 1'b1) begin $display("[ERROR] W1 load"); errors = errors + 1; end
        load1 = 0; en1 = 1; dir1 = 0; serial1 = 1'b0;
        @(posedge clk); #1; if (q1 !== 1'b0) begin $display("[ERROR] W1 left shift"); errors = errors + 1; end
        dir1 = 1; serial1 = 1'b1;
        @(posedge clk); #1; if (q1 !== 1'b1) begin $display("[ERROR] W1 right shift"); errors = errors + 1; end
        en1 = 0; serial1 = 1'b0;
        @(posedge clk); #1; if (q1 !== 1'b1) begin $display("[ERROR] W1 hold"); errors = errors + 1; end

        if (errors == 0) $display("[PASS] shift load/hold/direction/priority, random + WIDTH=1");
        else begin $display("[FAIL] shift_register: %0d error(s)", errors); $fatal(1); end
        $finish;
    end
endmodule
