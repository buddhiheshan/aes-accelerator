addi    x0, x0, 0
addi    x0, x0, 0

addi    x3, x0, 0x300       # 30000193
addi    x4, x0, 0x100       # 10000213

# loading the key from the SRAM and store in the AES key register
lw      x2, 0(x4)           # 00022103
sw      x2, 16(x3)          # 0021a823
lw      x2, 4(x4)           # 00422103
sw      x2, 20(x3)          # 0021aa23
lw      x2, 8(x4)           # 00822103
sw      x2, 24(x3)          # 0021ac23
lw      x2, 12(x4)          # 00c22103
sw      x2, 28(x3)          # 0021ae23

# loading the plain text from the SRAM and store in the AES plain text register
lw      x2, 16(x4)          # 01022103
sw      x2, 32(x3)          # 0221a023
lw      x2, 20(x4)          # 01422103
sw      x2, 36(x3)          # 0221a223
lw      x2, 24(x4)          # 01822103
sw      x2, 40(x3)          # 0221a423
lw      x2, 28(x4)          # 01c22103
sw      x2, 44(x3)          # 0221a623

# starting the encryption
addi    x2, x0, 1           # 00100113
sw      x2, 0(x3)           # 0021a023


lb      x9, 4(x3)           # 00418483
andi    x9, x9, 2           # 0024f493
beq     x9, x0, -8          # fe048ce3   (branch backward two instructions)

# read the cipher text from AES cipher text register
lw      x10, 64(x3)         # 0401a503
lw      x11, 68(x3)         # 0441a583
lw      x12, 72(x3)         # 0481a603
lw      x13, 76(x3)         # 04c1a683

addi    x0, x0, 0
addi    x0, x0, 0

addi    x3, x0, 0x300       # 30000193
addi    x4, x0, 0x100       # 10000213

lw      x2, 0(x4)           # 00022103
sw      x2, 16(x3)          # 0021a823

lw      x2, 4(x4)           # 00422103
sw      x2, 20(x3)          # 0021aa23

lw      x2, 8(x4)           # 00822103
sw      x2, 24(x3)          # 0021ac23

lw      x2, 12(x4)          # 00c22103
sw      x2, 28(x3)          # 0021ae23

lw      x2, 16(x4)          # 01022103
sw      x2, 32(x3)          # 0221a023

lw      x2, 20(x4)          # 01422103
sw      x2, 36(x3)          # 0221a223

lw      x2, 24(x4)          # 01822103
sw      x2, 40(x3)          # 0221a423

lw      x2, 28(x4)          # 01c22103
sw      x2, 44(x3)          # 0221a623

addi    x2, x0, 1           # 00100113
sw      x2, 0(x3)           # 0021a023

lb      x9, 4(x3)           # 00418483
andi    x9, x9, 2           # 0024f493
beq     x9, x0, -8          # fe048ce3   (branch backward two instructions)

lw      x10, 64(x3)         # 0401a503
lw      x11, 68(x3)         # 0441a583
lw      x12, 72(x3)         # 0481a603
lw      x13, 76(x3)         # 04c1a683

# store the cipher text in the AES cipher text register
sw      x10, 48(x3)         # 02a1a823
sw      x11, 52(x3)         # 02b1aa23
sw      x12, 56(x3)         # 02c1ac23
sw      x13, 60(x3)         # 02d1ae23

# starting the decryption
addi    x2, x0, 2           # 00200113
sw      x2, 0(x3)           # 0021a023

# polling for the done status
lb      x9, 4(x3)           # 00418483
andi    x9, x9, 8           # 0084f493
beq     x9, x0, -8          # fe048ce3 (branch backward two instructions)

# read the plain text from AES cipher text register
lw      x10, 80(x3)         # 0501a503
lw      x11, 84(x3)         # 0541a583
lw      x12, 88(x3)         # 0581a603
lw      x13, 92(x3)         # 05c1a683
