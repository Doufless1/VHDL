# One entry point for every flow in the repository. `make help` lists them.

PYTHON ?= python3
JOBS   ?= 4

.PHONY: help all test synth report formal mutation figures clean

help:
	@echo "make test      simulate every testbench (VUnit + GHDL)          ~30 s"
	@echo "make synth     synthesize every design, reject accidental latches"
	@echo "make report    ... and print a resource-usage table (Yosys)"
	@echo "make formal    prove the PSL properties (Yosys + Z3)            ~35 s"
	@echo "make mutation  inject 20 bugs, check the tests catch each one   ~1 min"
	@echo "make figures   re-simulate and redraw the figures in docs/images/"
	@echo "make all       test + synth + formal + mutation (what CI runs)"
	@echo "make clean     remove all generated files"

all: test synth formal mutation

test:
	$(PYTHON) run.py -p $(JOBS)

synth:
	$(PYTHON) scripts/synth_check.py

report:
	$(PYTHON) scripts/synth_check.py --report

formal:
	$(PYTHON) scripts/formal_check.py

mutation:
	$(PYTHON) scripts/mutation_test.py

figures:
	$(PYTHON) scripts/make_figures.py

clean:
	rm -rf vunit_out build
