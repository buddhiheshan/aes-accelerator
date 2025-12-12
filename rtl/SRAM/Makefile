SIM       ?= vcs
SIM_FLAGS ?= -full64 -sverilog -kdb -lca -debug_access+all -timescale=1ns/1ps

BUILD_DIR ?= build

SRCS := sram_axi_wrapper.v
IP_SRAM := /ip/tsmc/tsmc16adfp/sram/VERILOG/N16ADFP_SRAM_100a.v
TB   := tb/tb_axi_sram.v

SIM_EXE := $(BUILD_DIR)/tb_axi_sram

.PHONY: all run clean help

# Build and run the SRAM AXI testbench
all: $(SIM_EXE)
	@echo "Running $(SIM_EXE)"
	$(SIM_EXE)

$(SIM_EXE): $(SRCS) $(IP_SRAM) $(TB) | $(BUILD_DIR)
	@echo "Compiling tb_axi_sram with vcs"
	$(SIM) $(SIM_FLAGS) -o $@ -top tb_axi_sram $(SRCS) $(IP_SRAM) $(TB)

$(BUILD_DIR):
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR)

help:
	@echo "Make targets:"
	@echo "  all   - Build and run tb_axi_sram (same as 'run')"
	@echo "  run   - Build and run tb_axi_sram"
	@echo "  clean - Remove build outputs"
	@echo "  help  - Show this help"
	@echo ""
	@echo "Variables:"
	@echo "  SIM        (default: vcs)"
	@echo "  SIM_FLAGS  (default: -full64 -sverilog -kdb -lca -debug_access+all -timescale=1ns/1ps)"
	@echo "  BUILD_DIR  (default: build)"
