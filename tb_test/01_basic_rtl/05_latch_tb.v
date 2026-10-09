`timescale 1ns/1ps
// 测试契约：gate=1 时透明，gate=0 时保持（电平敏感，非边沿触发）。
// 覆盖：
//   1. 定向：透明、保持、重新打开立即透明（不等待任何“边沿”）；
//   2. gate 与 d 同时变化：关闭时保持旧值、打开时立即取新值；
//   3. 随机序列（400 步）与黄金模型比对；
//   4. WIDTH=1 参数化实例。
module tb_05_latch;
    localparam integer WIDTH = 8;
    reg gate;
    reg [WIDTH-1:0] d;
    wire [WIDTH-1:0] q;
    reg [WIDTH-1:0] model_q;
    integer errors, i, seed;

    gated_latch #(.WIDTH(WIDTH)) dut (.gate(gate), .d(d), .q(q));

    // WIDTH=1 参数化实例。
    reg gate1, d1;
    wire q1;
    gated_latch #(.WIDTH(1)) dut1 (.gate(gate1), .d(d1), .q(q1));

    task expect_q;
        input [WIDTH-1:0] expected;
        begin
            #1;
            if (q !== expected) begin
                $display("[ERROR] gate=%b d=%h expected q=%h actual=%h", gate, d, expected, q);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0; seed = 32'h1A7C_0005;
        gate = 0; d = 8'h00; gate1 = 0; d1 = 0;
        #2;
        gate = 1; d = 8'h12; expect_q(8'h12);
        // gate 一直为高时连续修改 d，q 每次都必须跟随。
        d = 8'hA5; expect_q(8'hA5);
        d = 8'h3C; expect_q(8'h3C);

        gate = 0;
        d = 8'hFF; expect_q(8'h3C);
        d = 8'h00; expect_q(8'h3C);

        // 再次打开后立即透明，而不是等待任意“边沿”。
        gate = 1; expect_q(8'h00);
        #3; d = 8'h69; expect_q(8'h69);
        gate = 0; d = 8'h96; expect_q(8'h69);

        // gate 与 d 同时变化。
        gate = 0; d = 8'hA5; #2;           // 建立保持值 A5
        gate = 1; d = 8'h5A; expect_q(8'h5A); // 打开的同时改 d → 立即取新值
        gate = 0; d = 8'h33; expect_q(8'h5A); // 关闭的同时改 d → 保持旧值
        gate = 1; expect_q(8'h33);            // 重新打开 → 取最新值

        // 随机序列 + 黄金模型。
        gate = 0; d = 8'h00; #2; model_q = q;
        for (i = 0; i < 400; i = i + 1) begin
            gate = $random(seed) & 1'b1;
            d    = $random(seed);
            if (gate) model_q = d;
            #1;
            if (q !== model_q) begin
                $display("[ERROR] random gate=%b d=%h expected=%h actual=%h", gate, d, model_q, q);
                errors = errors + 1;
            end
        end

        // WIDTH=1 实例。
        gate1 = 0; d1 = 0; #2;
        gate1 = 1; d1 = 1; #1;
        if (q1 !== 1'b1) begin $display("[ERROR] W1 transparent"); errors = errors + 1; end
        gate1 = 0; d1 = 0; #1;
        if (q1 !== 1'b1) begin $display("[ERROR] W1 hold"); errors = errors + 1; end
        gate1 = 1; #1;
        if (q1 !== 1'b0) begin $display("[ERROR] W1 re-open"); errors = errors + 1; end

        if (errors == 0) $display("[PASS] latch transparency/hold, simultaneous changes, random + WIDTH=1");
        else begin $display("[FAIL] latch: %0d error(s)", errors); $fatal(1); end
        $finish;
    end
endmodule
