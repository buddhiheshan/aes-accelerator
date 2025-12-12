SIM       ?= vcs
SIM_FLAGS ?= -full64 -sverilog -kdb -lca -debug_access+all -timescale=1ns/1ps

BUILD_DIR ?= build
FILELIST  ?= filelist.f

SIM_EXE := $(BUILD_DIR)/tb_system_top

.PHONY: all top clean help

all: top

# Build and run tb_system_top using the provided filelist
top: $(SIM_EXE)
	@echo "Running $(SIM_EXE)"
	$(SIM_EXE)

$(SIM_EXE): $(FILELIST) | $(BUILD_DIR)
	@echo "Compiling tb_system_top with vcs using $(FILELIST)"
	$(SIM) $(SIM_FLAGS) -o $@ -top tb_system_top -f $(FILELIST)

$(BUILD_DIR):
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR)

help:
	@echo "Make targets:"
	@echo "  all  - Build and run tb_system_top (same as 'top')"
	@echo "  top  - Build and run tb_system_top using filelist.f"
	@echo "  clean- Remove build outputs"
	@echo "  help - Show this help"
	@echo ""
	@echo "Variables:"
	@echo "  SIM        (default: vcs)"
	@echo "  SIM_FLAGS  (default: -full64 -sverilog -kdb -lca -debug_access+all -timescale=1ns/1ps)"
	@echo "  BUILD_DIR  (default: build)"
	@echo "  FILELIST   (default: filelist.f)"

