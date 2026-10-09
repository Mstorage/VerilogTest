PYTHON ?= python
Q ?= all

.PHONY: help list status compile compile-all run wave view all clean clean-waves regenerate

help:
	@$(PYTHON) -c "print('Commands:\n  make list\n  make status\n  make compile Q=01_basic_rtl/01_mux_2_4\n  make compile-all\n  make run Q=01_basic_rtl/01_mux_2_4\n  make wave Q=01_basic_rtl/01_mux_2_4\n  make view Q=01_basic_rtl/01_mux_2_4\n  make all\n  make clean\n  make clean-waves')"

list:
	@$(PYTHON) tools/run_tests.py list

status:
	@$(PYTHON) tools/run_tests.py status

compile:
	@$(PYTHON) tools/run_tests.py compile --question "$(Q)"

compile-all:
	@$(PYTHON) tools/run_tests.py compile --question all

run:
	@$(PYTHON) tools/run_tests.py run --question "$(Q)"

wave:
	@$(PYTHON) tools/run_tests.py wave --question "$(Q)"

view:
	@$(PYTHON) tools/run_tests.py view --question "$(Q)"

all:
	@$(PYTHON) tools/run_tests.py all --question all

clean:
	@$(PYTHON) tools/run_tests.py clean

clean-waves:
	@$(PYTHON) tools/run_tests.py clean-waves

regenerate:
	@$(PYTHON) tools/scaffold_exercises.py
