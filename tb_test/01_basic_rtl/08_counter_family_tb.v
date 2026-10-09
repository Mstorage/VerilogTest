`timescale 1ns/1ps
// mode: 00=自然二进制回卷，01=模 MODULO 回卷，10=饱和，11=保持；up=1 加 / 0 减。
// wrap/saturated 为边界脉冲，只持续一拍。覆盖：
//   1. 定向：4 种模式 × 加减 × 边界（回卷、饱和、保持、en=0）；
//      mode=10 在 0 处向下同样饱和；mode=11 与 en/up 无关；
//   2. 随机序列（300 拍）与黄金模型比对；模式切换前先复位，保证状态在每种模式下都合法；
//   3. WIDTH=8/MODULO=100 第二个实例验证参数化（99/255 边界）。
module tb_08_counter_family;
    localparam integer WIDTH = 4;
    localparam integer MODULO = 10;
    reg clk, rst_n, en, up;
    reg [1:0] mode;
    wire [WIDTH-1:0] q;
    wire wrap, saturated;
    reg [WIDTH-1:0] model_q;
    reg model_wrap, model_sat;
    reg [1:0] next_mode;
    reg next_en, next_up;
    integer errors, i, seed;

    counter_family #(.WIDTH(WIDTH), .MODULO(MODULO)) dut (
        .clk(clk), .rst_n(rst_n), .en(en), .up(up), .mode(mode),
        .q(q), .wrap(wrap), .saturated(saturated)
    );
    always #5 clk = ~clk;

    // WIDTH=8 / MODULO=100 参数化实例（共享 clk/rst_n）。
    reg en8, up8;
    reg [1:0] mode8;
    wire [7:0] q8;
    wire wrap8, saturated8;
    counter_family #(.WIDTH(8), .MODULO(100)) dut8 (
        .clk(clk), .rst_n(rst_n), .en(en8), .up(up8), .mode(mode8),
        .q(q8), .wrap(wrap8), .saturated(saturated8)
    );

    task tick_expect;
        input [WIDTH-1:0] expected_q;
        input expected_wrap;
        input expected_sat;
        begin
            @(posedge clk); #1;
            if (q !== expected_q || wrap !== expected_wrap || saturated !== expected_sat) begin
                $display("[ERROR] mode=%b up=%b exp q/wrap/sat=%0d/%b/%b got=%0d/%b/%b",
                         mode, up, expected_q, expected_wrap, expected_sat, q, wrap, saturated);
                errors = errors + 1;
            end
        end
    endtask

    task tick8_expect;
        input [7:0] expected_q;
        input expected_wrap;
        input expected_sat;
        begin
            @(posedge clk); #1;
            if (q8 !== expected_q || wrap8 !== expected_wrap || saturated8 !== expected_sat) begin
                $display("[ERROR] W8 mode=%b up=%b exp q/wrap/sat=%0d/%b/%b got=%0d/%b/%b",
                         mode8, up8, expected_q, expected_wrap, expected_sat, q8, wrap8, saturated8);
                errors = errors + 1;
            end
        end
    endtask

    task reset_counter;
        begin
            @(negedge clk); rst_n = 0; #1;
            if (q !== 0 || wrap !== 0 || saturated !== 0) begin
                $display("[ERROR] reset did not clear outputs"); errors = errors + 1;
            end
            rst_n = 1;
        end
    endtask

    task reset_counter8;
        begin
            @(negedge clk); rst_n = 0; #1;
            if (q8 !== 0 || wrap8 !== 0 || saturated8 !== 0) begin
                $display("[ERROR] W8 reset did not clear outputs"); errors = errors + 1;
            end
            rst_n = 1;
        end
    endtask

    // 一拍黄金模型：阻塞更新模型状态，输出期望脉冲。
    task model_tick;
        begin
            model_wrap = 0; model_sat = 0;
            if (en) begin
                case (mode)
                    2'b00: begin
                        if (up) begin
                            model_wrap = (model_q == {WIDTH{1'b1}});
                            model_q = model_q + 1'b1;
                        end else begin
                            model_wrap = (model_q == 0);
                            model_q = model_q - 1'b1;
                        end
                    end
                    2'b01: begin
                        if (up) begin
                            if (model_q == MODULO[WIDTH-1:0] - 1'b1) begin model_q = 0; model_wrap = 1; end
                            else model_q = model_q + 1'b1;
                        end else begin
                            if (model_q == 0) begin model_q = MODULO[WIDTH-1:0] - 1'b1; model_wrap = 1; end
                            else model_q = model_q - 1'b1;
                        end
                    end
                    2'b10: begin
                        if (up) begin
                            if (model_q == {WIDTH{1'b1}}) model_sat = 1;
                            else model_q = model_q + 1'b1;
                        end else begin
                            if (model_q == 0) model_sat = 1;
                            else model_q = model_q - 1'b1;
                        end
                    end
                    default: ; // mode=11：保持
                endcase
            end
        end
    endtask

    initial begin
        errors = 0; seed = 32'hC0DE_0008;
        clk = 0; rst_n = 0; en = 0; up = 1; mode = 0;
        en8 = 0; up8 = 1; mode8 = 0;
        #2; rst_n = 1;

        // 自然二进制向下回卷：0 -> 15。
        en = 1; mode = 2'b00; up = 0;
        tick_expect(4'd15, 1'b1, 1'b0);
        tick_expect(4'd14, 1'b0, 1'b0);

        // 自然二进制向上回卷：15 -> 0。
        reset_counter(); mode = 2'b00; up = 1; en = 1;
        for (i = 1; i <= 15; i = i + 1) tick_expect(i[WIDTH-1:0], 1'b0, 1'b0);
        tick_expect(4'd0, 1'b1, 1'b0);

        // 模 10 向上：8 -> 9 -> 0，并检查 wrap 仅持续一拍。
        reset_counter(); mode = 2'b01; up = 1; en = 1;
        for (i = 1; i <= 8; i = i + 1) tick_expect(i[WIDTH-1:0], 1'b0, 1'b0);
        tick_expect(4'd9, 1'b0, 1'b0);
        tick_expect(4'd0, 1'b1, 1'b0);
        tick_expect(4'd1, 1'b0, 1'b0);

        // 模 10 向下：0 -> 9，数回 0 再次回卷。
        reset_counter(); mode = 2'b01; up = 0; en = 1;
        tick_expect(4'd9, 1'b1, 1'b0);
        tick_expect(4'd8, 1'b0, 1'b0);
        for (i = 7; i >= 0; i = i - 1) tick_expect(i[WIDTH-1:0], 1'b0, 1'b0);
        tick_expect(4'd9, 1'b1, 1'b0);

        // 模计数期间 en=0：状态与标志都不得变化。
        @(negedge clk); en = 0;
        tick_expect(4'd9, 1'b0, 1'b0);
        tick_expect(4'd9, 1'b0, 1'b0);
        en = 1;
        tick_expect(4'd8, 1'b0, 1'b0);

        // 饱和向上：到 15 后继续请求应保持并置 saturated（持续一拍）。
        reset_counter(); mode = 2'b10; up = 1; en = 1;
        for (i = 1; i <= 15; i = i + 1) tick_expect(i[WIDTH-1:0], 1'b0, 1'b0);
        tick_expect(4'd15, 1'b0, 1'b1);
        tick_expect(4'd15, 1'b0, 1'b1);   // 连续请求仍饱和
        en = 0; tick_expect(4'd15, 1'b0, 1'b0);
        // 从饱和态转减，正常回退且不饱和。
        en = 1; up = 0;
        tick_expect(4'd14, 1'b0, 1'b0);

        // 饱和向下：0 处继续减 → 保持 0 且 saturated=1。
        reset_counter(); mode = 2'b10; up = 0; en = 1;
        tick_expect(4'd0, 1'b0, 1'b1);
        tick_expect(4'd0, 1'b0, 1'b1);
        up = 1;
        tick_expect(4'd1, 1'b0, 1'b0);

        // mode=11 必须保持，与 en/up 无关。
        reset_counter(); mode = 2'b11; en = 1; up = 1;
        tick_expect(4'd0, 1'b0, 1'b0);
        up = 0;
        tick_expect(4'd0, 1'b0, 1'b0);

        // 随机序列 + 黄金模型；模式切换前先复位，保证 q=0 在所有模式下合法。
        @(negedge clk); rst_n = 0; #1; model_q = 0; rst_n = 1;
        mode = 2'b00; en = 1; up = 1;
        for (i = 0; i < 300; i = i + 1) begin
            @(negedge clk);
            next_mode = $random(seed) & 2'b11;
            next_en   = $random(seed) & 1'b1;
            next_up   = $random(seed) & 1'b1;
            if (next_mode !== mode) begin
                rst_n = 0; #1;
                model_q = 0;
                if (q !== 0 || wrap !== 0 || saturated !== 0) begin
                    $display("[ERROR] random mode-switch reset"); errors = errors + 1;
                end
                rst_n = 1;
            end
            mode = next_mode; en = next_en; up = next_up;
            @(posedge clk); #1;
            model_tick;
            if (q !== model_q || wrap !== model_wrap || saturated !== model_sat) begin
                $display("[ERROR] random mode/en/up=%b/%b/%b exp q/wrap/sat=%0d/%b/%b got=%0d/%b/%b",
                         mode, en, up, model_q, model_wrap, model_sat, q, wrap, saturated);
                errors = errors + 1;
            end
        end

        // WIDTH=8 / MODULO=100：模 100 回卷（99->0 / 0->99）。
        reset_counter8(); mode8 = 2'b01; up8 = 1; en8 = 1;
        for (i = 1; i <= 99; i = i + 1) tick8_expect(i[7:0], 1'b0, 1'b0);
        tick8_expect(8'd0, 1'b1, 1'b0);
        up8 = 0;
        tick8_expect(8'd99, 1'b1, 1'b0);
        tick8_expect(8'd98, 1'b0, 1'b0);

        // WIDTH=8 自然回卷：255 -> 0。
        reset_counter8(); mode8 = 2'b00; up8 = 1; en8 = 1;
        for (i = 1; i <= 255; i = i + 1) tick8_expect(i[7:0], 1'b0, 1'b0);
        tick8_expect(8'd0, 1'b1, 1'b0);

        // WIDTH=8 饱和：255 处向上饱和，0 处向下饱和。
        reset_counter8(); mode8 = 2'b10; up8 = 1; en8 = 1;
        for (i = 1; i <= 255; i = i + 1) tick8_expect(i[7:0], 1'b0, 1'b0);
        tick8_expect(8'd255, 1'b0, 1'b1);
        en8 = 0; tick8_expect(8'd255, 1'b0, 1'b0);
        reset_counter8(); mode8 = 2'b10; up8 = 0; en8 = 1;
        tick8_expect(8'd0, 1'b0, 1'b1);

        if (errors == 0) $display("[PASS] counter modes, boundaries, random golden-model + WIDTH=8");
        else begin $display("[FAIL] counter_family: %0d error(s)", errors); $fatal(1); end
        $finish;
    end
endmodule
