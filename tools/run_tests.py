#!/usr/bin/env python3
"""Small cross-platform runner used by the Makefile."""

from __future__ import annotations

import argparse
import re
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RTL_ROOT = ROOT / "test"
TB_ROOT = ROOT / "tb_test"
BUILD_ROOT = ROOT / ".build"
WAVE_ROOT = ROOT / "waveforms"
TODO_MARKER = "TODO_IMPLEMENT"
TODO_PATTERN = re.compile(r"^\s*//\s*TODO_IMPLEMENT\s*:", re.MULTILINE)


@dataclass(frozen=True)
class Exercise:
    key: str
    rtl: Path
    tb: Path

    @property
    def completed(self) -> bool:
        # The file header mentions the marker in its instructions. Only the
        # dedicated placeholder line means that implementation is unfinished.
        return TODO_PATTERN.search(self.rtl.read_text(encoding="utf-8")) is None


def discover() -> list[Exercise]:
    exercises = []
    for rtl in sorted(RTL_ROOT.glob("*/*.v")):
        relative = rtl.relative_to(RTL_ROOT)
        key = relative.with_suffix("").as_posix()
        tb = TB_ROOT / relative.parent / f"{relative.stem}_tb.v"
        exercises.append(Exercise(key, rtl, tb))
    return exercises


def select(exercises: list[Exercise], query: str | None) -> list[Exercise]:
    if not query or query in {"all", "*"}:
        return exercises
    normalized = query.replace("\\", "/").removesuffix(".v").removesuffix("_tb")
    exact = [item for item in exercises if item.key == normalized]
    if exact:
        return exact
    # A category name intentionally selects every exercise below it. This
    # makes commands such as `make run Q=01_basic_rtl` useful for a section.
    category_matches = [item for item in exercises if item.key.startswith(normalized.rstrip("/") + "/")]
    if category_matches:
        return category_matches
    matches = [item for item in exercises if item.key.endswith("/" + normalized) or normalized in item.key]
    if len(matches) == 1:
        return matches
    if not matches:
        raise SystemExit(f"Unknown question: {query}. Use 'make list' to see valid IDs.")
    names = "\n  ".join(item.key for item in matches)
    raise SystemExit(f"Ambiguous question '{query}'. Matches:\n  {names}")


def require_tool(name: str) -> str:
    path = shutil.which(name)
    if not path:
        raise SystemExit(f"Required tool '{name}' was not found in PATH.")
    return path


def waveform_path(item: Exercise) -> Path:
    return (WAVE_ROOT / item.key).with_suffix(".vcd")


def compile_one(item: Exercise, wave: bool = False) -> Path | None:
    if not item.tb.exists():
        print(f"[ERROR] {item.key}: missing {item.tb.relative_to(ROOT)}")
        return None
    compiler = require_tool("iverilog")
    output = BUILD_ROOT / item.key
    output.parent.mkdir(parents=True, exist_ok=True)
    output = output.with_suffix(".vvp")
    top = "tb_" + item.rtl.stem
    command = [compiler, "-g2012", "-Wall", "-s", top]
    if wave:
        vcd = waveform_path(item)
        vcd.parent.mkdir(parents=True, exist_ok=True)
        dumper = output.with_suffix(".wave_dump.v")
        dumper.write_text(
            "`timescale 1ns/1ps\n"
            "module codex_wave_dump;\n"
            "    initial begin\n"
            f'        $dumpfile("{vcd.as_posix()}");\n'
            f"        $dumpvars(0, {top});\n"
            "    end\n"
            "endmodule\n",
            encoding="utf-8",
        )
        command.extend(["-s", "codex_wave_dump"])
    command.extend(["-o", str(output), str(item.rtl), str(item.tb)])
    if wave:
        command.append(str(dumper))
    result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
    if result.returncode:
        print(f"[COMPILE FAIL] {item.key}")
        if result.stdout.strip():
            print(result.stdout.rstrip())
        if result.stderr.strip():
            print(result.stderr.rstrip())
        return None
    print(f"[COMPILE PASS] {item.key}")
    return output


def run_one(item: Exercise, allow_incomplete: bool = False, wave: bool = False) -> bool:
    if not item.completed and not allow_incomplete:
        print(f"[INCOMPLETE] {item.key}: remove {TODO_MARKER} after implementing the RTL")
        return False
    if not item.completed:
        print(f"[WARNING] {item.key}: {TODO_MARKER} is still present; running for debug")
    output = compile_one(item, wave=wave)
    if output is None:
        return False
    simulator = require_tool("vvp")
    result = subprocess.run([simulator, str(output)], cwd=ROOT, text=True, capture_output=True)
    if result.stdout.strip():
        print(result.stdout.rstrip())
    if result.stderr.strip():
        print(result.stderr.rstrip())
    if wave:
        vcd = waveform_path(item)
        if vcd.exists():
            print(f"[WAVE] {vcd}")
        else:
            print(f"[WAVE FAIL] {item.key}: VCD was not created")
    if result.returncode:
        print(f"[RUN FAIL] {item.key}")
        return False
    print(f"[RUN PASS] {item.key}")
    return True


def open_in_vscode(item: Exercise) -> bool:
    vcd = waveform_path(item)
    if not vcd.exists():
        print(f"[VIEW FAIL] Waveform does not exist: {vcd}")
        return False
    code = shutil.which("code")
    if not code:
        print(f"[VIEW] Open this file manually in VS Code with Surfer: {vcd}")
        return False
    try:
        subprocess.Popen([code, "--reuse-window", str(vcd)], cwd=ROOT)
    except OSError as exc:
        print(f"[VIEW FAIL] Could not start VS Code: {exc}")
        print(f"Open this file manually with Surfer: {vcd}")
        return False
    print(f"[VIEW] Sent to VS Code/Surfer: {vcd}")
    return True


def print_status(exercises: list[Exercise]) -> int:
    complete = 0
    missing_tb = 0
    for item in exercises:
        state = "DONE" if item.completed else "TODO"
        if item.completed:
            complete += 1
        if not item.tb.exists():
            state = "NO_TB"
            missing_tb += 1
        print(f"[{state:5}] {item.key}")
    print(f"\nSummary: {complete}/{len(exercises)} implemented; {missing_tb} missing testbench(es).")
    # Status is informational: unfinished exercises are expected and should not
    # make `make status` itself fail. A missing paired testbench is structural.
    return 1 if missing_tb else 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=("list", "status", "compile", "run", "wave", "view", "all", "clean", "clean-waves"))
    parser.add_argument("--question", "-q")
    parser.add_argument("--allow-incomplete", action="store_true")
    args = parser.parse_args()
    exercises = discover()
    if args.action == "clean":
        if BUILD_ROOT.exists():
            shutil.rmtree(BUILD_ROOT)
        print("Build artifacts removed.")
        return 0
    if args.action == "clean-waves":
        if WAVE_ROOT.exists():
            shutil.rmtree(WAVE_ROOT)
        print("Waveform files removed.")
        return 0
    if not exercises:
        print("No exercises found. Run tools/scaffold_exercises.py first.")
        return 2
    if args.action == "list":
        for item in exercises:
            print(item.key)
        return 0
    if args.action == "status":
        return print_status(exercises)
    selected = select(exercises, args.question)
    if args.action == "compile":
        results = [compile_one(item) is not None for item in selected]
    elif args.action == "run":
        # A normal single-question simulation also records a VCD so every
        # debug run has a matching waveform. Batch `all` stays waveform-free.
        results = [run_one(item, allow_incomplete=True, wave=True) for item in selected]
    elif args.action in {"wave", "view"}:
        if args.action == "view" and len(selected) != 1:
            raise SystemExit("'view' requires one question. Example: make view Q=01_mux_2_4")
        # Wave generation is a debugging action, so it is allowed before the
        # completion marker is removed. Test failures still return non-zero.
        results = [run_one(item, allow_incomplete=True, wave=True) for item in selected]
        if args.action == "view":
            opened = open_in_vscode(selected[0])
            results[0] = results[0] and opened
    else:
        results = [run_one(item, False) for item in selected]
    passed = sum(results)
    print(f"\nResult: {passed}/{len(results)} passed.")
    return 0 if all(results) else 1


if __name__ == "__main__":
    sys.exit(main())
