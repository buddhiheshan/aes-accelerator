SIM       ?= vcs
SIM_FLAGS ?= -full64 -sverilog -kdb -lca -debug_access+all -timescale=1ns/1ps

BUILD_DIR ?= build

PKG_SRCS := $(wildcard pkgs/*.sv)
# Filter out testbenches (tb_*.sv) from the RTL compile set.
RTL_SRCS := $(filter-out tb/%,$(filter-out tb_%.sv,$(wildcard *.sv)))

# Collect testbenches and ensure tb_top_aes is last.
TB_FILES_ALL := $(wildcard tb/tb_*.sv)
TB_FILES     := $(filter-out tb/tb_top_aes.sv,$(TB_FILES_ALL)) tb/tb_top_aes.sv
TB_TOPS      := $(notdir $(basename $(TB_FILES)))
TB_EXES      := $(addprefix $(BUILD_DIR)/,$(TB_TOPS))

.PHONY: all top clean help

# Build and run every testbench; tb_top_aes runs last.
all: $(TB_EXES)
	@set -e; \
	for tb in $(TB_TOPS); do \
	  exe="$(BUILD_DIR)/$$tb"; \
	  echo "Running $$tb from $$exe"; \
	  "$$exe"; \
	done

# Build and run only tb_top_aes
top: $(BUILD_DIR)/tb_top_aes
	@echo "Running $(BUILD_DIR)/tb_top_aes"
	$(BUILD_DIR)/tb_top_aes

# Pattern rule to compile each testbench
$(BUILD_DIR)/%: tb/%.sv $(PKG_SRCS) $(RTL_SRCS) | $(BUILD_DIR)
	@echo "Compiling $* with vcs"
	$(SIM) $(SIM_FLAGS) -o $@ -top $* $(PKG_SRCS) $(RTL_SRCS) $<

$(BUILD_DIR):
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR)

help:
	@echo "Make targets:"
	@echo "  all  - Build and run tb_top_aes (same as 'top')"
	@echo "  top  - Build and run tb_top_aes"
	@echo "  clean- Remove build outputs"
	@echo "  help - Show this help"
	@echo ""
	@echo "Variables:"
	@echo "  SIM        (default: vcs)"
	@echo "  SIM_FLAGS  (default: -full64 -sverilog -kdb -lca -debug_access+all -timescale=1ns/1ps)"
	@echo "  BUILD_DIR  (default: build)"
