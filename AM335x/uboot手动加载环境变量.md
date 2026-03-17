MYIR># mtdparts

device nand0 <omap2-nand.0>, # parts = 11
 #: name                size            offset          mask_flags
 0: NAND.SPL            0x00020000      0x00000000      0
 1: NAND.SPL.backup1    0x00020000      0x00020000      0
 2: NAND.SPL.backup2    0x00020000      0x00040000      0
 3: NAND.SPL.backup3    0x00020000      0x00060000      0
 4: NAND.u-boot-spl-os  0x00040000      0x00080000      0
 5: NAND.u-boot         0x00100000      0x000c0000      0
 6: NAND.u-boot-env     0x00020000      0x001c0000      0
 7: NAND.u-boot-env.backup10x00020000   0x001e0000      0
 8: NAND.kernel         0x00800000      0x00200000      0
 9: NAND.rootfs         0x0d600000      0x00a00000      0
10: NAND.userdata       0x12000000      0x0e000000      0

active partition: nand0,0 - (NAND.SPL) 0x00020000 @ 0x00000000

kernel:
nand read ${loadaddr} 0x200000 0x800000
fdt:
nand read ${fdtaddr} 0x80000 0x40000
rootfs:
run nandargs

bootz ${loadaddr} - ${fdtaddr}

run nandargs; nand read ${fdtaddr} NAND.u-boot-spl-os; nand read ${loadaddr} NAND.kernel;