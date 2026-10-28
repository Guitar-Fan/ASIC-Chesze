PROJECT_SOURCES = ../src/tt_um_guitarfan_ultimate_chess_clock.v ../src/ultimate_chess_clock.sv
TESTBENCH = ultimate_chess_clock_tb.sv
BUILD_DIR ?= /tmp/ultimate_chess_clock_obj

.PHONY: sim lint clean
sim:
	verilator --binary --trace --top-module ultimate_chess_clock_tb \
		-Wno-WIDTHEXPAND -Wno-TIMESCALEMOD \
		$(PROJECT_SOURCES) $(TESTBENCH) --Mdir $(BUILD_DIR)
	$(BUILD_DIR)/Vultimate_chess_clock_tb

lint:
	verilator --lint-only --language 1800-2012 \
		-Wno-WIDTHEXPAND -Wno-TIMESCALEMOD \
		$(PROJECT_SOURCES)

clean:
	rm -rf $(BUILD_DIR) *.vcd *.fst
