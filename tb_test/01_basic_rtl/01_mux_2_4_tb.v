`timescale 1ns/1ps
// 测试契约：sel=00/01/10/11 分别选择 in0/in1/in2/in3（2'b11 走缺省分支到 in3）。
// 覆盖：
//   1. 4 个选择值的映射关系，含全 0 / 全 1 数据边界；
//   2. 带种子的随机映射（200 组随机数据 × 4 个选择值）；
//   3. 被选输入变化时组合输出必须立即跟随（无 latch / 敏感列表缺失）；
//   4. 未选输入变化不得影响输出；
//   5. WIDTH=16 的第二个实例，验证位宽参数化。
module tb_01_mux_2_4;
    localparam integer WIDTH = 8;
    reg  [WIDTH-1:0] in0, in1, in2, in3;
    reg  [1:0] sel;
    wire [WIDTH-1:0] y;
    integer errors, i, seed;
    reg [WIDTH-1:0] exp;

    mux_2_4 #(.WIDTH(WIDTH)) dut (
        .in0(in0), .in1(in1), .in2(in2), .in3(in3), .sel(sel), .y(y)
    );

    // WIDTH=16 实例：位宽翻倍后映射关系必须不变。
    reg  [15:0] w_in0, w_in1, w_in2, w_in3;
    reg  [1:0]  w_sel;
    wire [15:0] w_y;
    mux_2_4 #(.WIDTH(16)) dut_w (
        .in0(w_in0), .in1(w_in1), .in2(w_in2), .in3(w_in3), .sel(w_sel), .y(w_y)
    );

    function [WIDTH-1:0] mux_model;
        input [WIDTH-1:0] a0, a1, a2, a3;
        input [1:0] s;
        begin
            case (s)
                2'b00:   mux_model = a0;
                2'b01:   mux_model = a1;
                2'b10:   mux_model = a2;
                default: mux_model = a3;   // 2'b11 走缺省路径
            endcase
        end
    endfunction

    task check_mux;
        input [1:0] s;
        input [WIDTH-1:0] expected;
        begin
            sel = s;
            #2;
            if (y !== expected) begin
                $display("[ERROR] sel=%b expected=%h actual=%h", s, expected, y);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0; seed = 32'h5EED_0F01;
        in0 = 8'h12; in1 = 8'hA5; in2 = 8'h3C; in3 = 8'hF0;
        check_mux(2'b00, in0);
        check_mux(2'b01, in1);
        check_mux(2'b10, in2);
        check_mux(2'b11, in3);

        // 随机映射：4 个选择值 × 200 组随机数据。
        for (i = 0; i < 200; i = i + 1) begin
            in0 = $random(seed); in1 = $random(seed);
            in2 = $random(seed); in3 = $random(seed);
            sel = i[1:0];
            exp = mux_model(in0, in1, in2, in3, sel);
            #1;
            if (y !== exp) begin
                $display("[ERROR] random sel=%b exp=%h act=%h", sel, exp, y);
                errors = errors + 1;
            end
        end

        // 边界数据：全 0 / 全 1 经每个选择值。
        in0 = 8'h00; in1 = 8'hFF; in2 = 8'hFF; in3 = 8'h00;
        check_mux(2'b00, 8'h00);
        check_mux(2'b01, 8'hFF);
        check_mux(2'b10, 8'hFF);
        check_mux(2'b11, 8'h00);

        // sel 不变时改变被选输入，组合输出必须立即更新，不能表现为 latch。
        sel = 2'b10;
        in2 = 8'h69;
        #2;
        if (y !== 8'h69) begin
            $display("[ERROR] output did not follow selected input; possible latch/incomplete sensitivity");
            errors = errors + 1;
        end

        // 改变未选输入不应影响输出。
        in0 = 8'hFF; in1 = 8'h00; in3 = 8'h55;
        #2;
        if (y !== 8'h69) begin
            $display("[ERROR] unselected input change altered output");
            errors = errors + 1;
        end

        // WIDTH=16 实例的定向检查。
        w_in0 = 16'h1234; w_in1 = 16'hABCD; w_in2 = 16'h8000; w_in3 = 16'h0001;
        w_sel = 2'b00; #2; if (w_y !== 16'h1234) begin $display("[ERROR] W16 sel=00 got=%h", w_y); errors = errors + 1; end
        w_sel = 2'b01; #2; if (w_y !== 16'hABCD) begin $display("[ERROR] W16 sel=01 got=%h", w_y); errors = errors + 1; end
        w_sel = 2'b10; #2; if (w_y !== 16'h8000) begin $display("[ERROR] W16 sel=10 got=%h", w_y); errors = errors + 1; end
        w_sel = 2'b11; #2; if (w_y !== 16'h0001) begin $display("[ERROR] W16 sel=11 got=%h", w_y); errors = errors + 1; end

        if (errors == 0) $display("[PASS] mux mapping, combinational behavior, random + WIDTH=16");
        else begin $display("[FAIL] mux: %0d error(s)", errors); $fatal(1); end
        $finish;
    end
endmodule
