RTL Directory Guide
===================

Layout (graphical)
------------------
```
rtl/
├─ aes/                      (AES block)
│  ├─ pkgs/                  (packages)
│  ├─ tb/                    (AES testbenches; tb_top_aes last)
│  ├─ *.sv                   (AES RTL)
│  └─ Makefile               (VCS build/run)
├─ SRAM/                     (SRAM AXI wrapper)
│  ├─ tb/                    (SRAM testbench)
│  ├─ sram_axi_wrapper.v
│  └─ Makefile               (VCS build/run)
├─ tb/
│  └─ tb_system_top.v        (system-level testbench)
├─ system_top.sv             (system top)
├─ cpu/
│  └─ picorv32.v
├─ filelist.f                (system compile list, includes external SRAM model)
└─ Makefile                  (build/run system tb_system_top)
```

Prerequisites
-------------
- Synopsys VCS available in PATH.
- External SRAM model path used in `filelist.f`: `/ip/tsmc/tsmc16adfp/sram/VERILOG/N16ADFP_SRAM_100a.v` (ensure accessible/readable).

Top-Level System Simulation
---------------------------
From `rtl/`:
- Build & run system bench: `make top` (uses `filelist.f`, produces and runs `build/tb_system_top`).
- Clean: `make clean`

AES Block Simulations
---------------------
From `rtl/aes/`:
- Run all AES benches (each tb in `tb/`, runs sequentially, `tb_top_aes` last): `make all`
- Run only top-level AES bench: `make top`
- Run specific bench (example): `make aes_core` (builds/runs `tb_aes_core`)
- Clean: `make clean`

SRAM Wrapper Simulation
-----------------------
From `rtl/SRAM/`:
- Build & run SRAM AXI bench: `make` (or `make all`, produces `build/tb_axi_sram` and runs it)
- Clean: `make clean`

Notes
-----
- VCS flags default to `-full64 -sverilog -kdb -lca -debug_access+all -timescale=1ns/1ps` in all Makefiles; override via `SIM_FLAGS=...` if needed.
- Build artifacts are placed under each module’s `build/` directory.

