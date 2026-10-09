# VerilogTest 使用说明

本目录把题单中的 79 道题整理为一题一文件的 RTL 练习环境。

## 目录

- `test/<模块>/<题号_题名>.v`：待完成的 RTL；文件头包含题目、难度、参数和端口约定。
- `tb_test/<模块>/<题号_题名>_tb.v`：同路径、同编号的基础自检 testbench。
- `tools/run_tests.py`：Makefile 使用的跨平台编译/运行器。
- `.build/`：仿真临时产物，由命令自动创建，可安全删除。
- `waveforms/`：按题目分类保存的 VCD 波形，由 `make wave/view` 自动创建。

## 常用命令

在 `VerilogTest` 目录执行：

```text
make help
make list
make status
make compile Q=01_basic_rtl/01_mux_2_4
make compile-all
make run Q=01_basic_rtl/01_mux_2_4
make wave Q=01_basic_rtl/01_mux_2_4
make view Q=01_basic_rtl/01_mux_2_4
make all
make clean
make clean-waves
```

`Q` 可以写完整 ID，也可以写能够唯一匹配的文件名片段，例如：

```text
make run Q=01_mux_2_4
make run Q=async_fifo_basic
```

也可以直接写分类名，批量运行该分类的所有题目：

```text
make run Q=01_basic_rtl
```

## 判定规则

1. 新题含有 `TODO_IMPLEMENT`，`make status` 会显示 `TODO`。
2. 完成 RTL 后删除该标记，`make status` 才会显示 `DONE`。
3. `make run Q=...` 即使保留完成标记也会继续编译和仿真，但打印 `WARNING`；这样可以边写边看波形。
4. `make compile-all` 可在尚未答题时检查全部骨架和 testbench 是否能编译。
5. `make all` 是正式全量检查：任何题目仍有完成标记、编译失败或测试失败时都会返回非零状态。

## 使用 Surfer 查看 VCD 波形

推荐安装 VS Code 扩展 **Surfer**（扩展 ID：`surfer-project.surfer`）。安装后直接打开 `.vcd` 文件即可进入波形界面。

```text
# 只生成波形；即使仍有 TODO 标记也会执行，便于调试中间版本
make wave Q=01_basic_rtl/01_mux_2_4

# 生成波形，然后调用 VS Code 打开；安装 Surfer 后会由 Surfer 接管
make view Q=01_basic_rtl/01_mux_2_4
```

波形保存为：

```text
waveforms/01_basic_rtl/01_mux_2_4.vcd
```

`make run` 和 `make wave` 每次都会覆盖刷新该题自己的 VCD；批量回归 `make all` 不生成波形，避免一次产生大量文件。`make view` 即使测试失败也会保留 VCD；如果 VS Code 没有自动使用 Surfer，请在文件标签或资源管理器中选择 **Open With... → Surfer**，并禁用其他同时接管 `.vcd` 的波形插件。

`01_basic_rtl` 的 12 份 testbench 已升级为题目专用的自校验功能测试：除定向边界向量外，全部加入带种子的随机激励与黄金参考模型逐拍比对，并用不同位宽/深度/模值的参数化实例验证参数化正确性，覆盖选择映射、优先级、穷举奇偶校验、异步复位、latch 透明性、逐位边沿、控制优先级、计数边界、格雷码穷举、寄存器堆、LZC 和桶形移位等经典错误（每份 tb 均已用注入 bug 的参考实现做过灵敏度验证：正确实现 PASS、带 bug 实现必 FAIL）。后续模块目前仍以接口级基线测试为主；FIFO、随机背压、CDC 异频/复位和总线乱序到达等场景还需要继续增强。

## 依赖

- Python 3.9+
- Icarus Verilog（`iverilog` 与 `vvp` 在 PATH 中）
- GNU Make 或兼容实现
- VS Code Surfer 扩展（仅查看波形需要）

`make regenerate` 只补回缺失文件，不覆盖已有 RTL、答案或已经增强的 testbench。
