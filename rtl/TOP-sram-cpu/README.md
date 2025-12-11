# Run in line: 
# vcs -full64 -kdb -sverilog /ip/tsmc/tsmc16adfp/sram/VERILOG/N16ADFP_SRAM_100a.v rtl/sram_axi_wrapper.v rtl/picorv32.v tb/system_top.v  -lca -debug_access+all 
# vcs -full64 -kdb -sverilog -f filelist.f -lca -debug_access+all
# verdi -dbdir simv.daidir
# firmware opcodes
000000000013   // 1. nop (addi x0, x0, 0)

000010000093   // 2. li x1, 0x100 (Set Write Address to 256)

0000deadc137   // 3. lui x2, 0xdeadc (Load Upper Immediate)

0000eef10113   // 4. addi x2, x2, -273 (Load Lower Immediate -> x2 = 0xDEADBEEF)

00000020a023   // 5. sw x2, 0(x1) (Store 0xDEADBEEF to Address 0x100)

00000000a183   // 6. lw x3, 0(x1) (Read from Address 0x100 into x3)

000000100073   // 7. ebreak (Stop/Trap)

000000000013   // 8. nop (Padding)

000000000013
000010000093
0000deadc137
0000eef10113
00000020a023
00000000a183
000000100073
000000000013
# aes opcodes
0000000010b7  // lui x1, 0x00001 (load address of 0x1000 indicating should go to AES)
0000deadc137  // lui x2, 0xdeadc (load upper immediate)
0000eef10113  // addi x2, x2, -273 (add to lower to get deadbeef)
000002202a23  // sw x2, 0x20(x1)  (write plaintext input x4)
000002202c23  // sw x2, 0x24(x1)
000002202e23  // sw x2, 0x28(x1)
000002203023  // sw x2, 0x2c(x1)
0000001001b3  // li x3, 0x1       (start encryption)
000000302023  // sw x3, 0x0(x1)   (with control address of 1)
00000013
30000093
00001093
0deadc137
eef10113
00202a23
00242c23
00282e23
002c3023
00100093
0000a023
00100073
