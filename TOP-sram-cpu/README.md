#firmware opcodes
000000000013   // 1. nop (addi x0, x0, 0)
000010000093   // 2. li x1, 0x100 (Set Write Address to 256)
0000deadc137   // 3. lui x2, 0xdeadc (Load Upper Immediate)
0000eef10113   // 4. addi x2, x2, -273 (Load Lower Immediate -> x2 = 0xDEADBEEF)
00000020a023   // 5. sw x2, 0(x1) (Store 0xDEADBEEF to Address 0x100)
00000000a183   // 6. lw x3, 0(x1) (Read from Address 0x100 into x3)
000000100073   // 7. ebreak (Stop/Trap)
000000000013   // 8. nop (Padding)
