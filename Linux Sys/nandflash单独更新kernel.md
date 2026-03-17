## 文件系统中更新kernel
查看分区表
```
cat /proc/mtd
```
```
dev:    size   erasesize  name
mtd0: 00020000 00020000 "NAND.SPL"
mtd1: 00020000 00020000 "NAND.SPL.backup1"
mtd2: 00020000 00020000 "NAND.SPL.backup2"
mtd3: 00020000 00020000 "NAND.SPL.backup3"
mtd4: 00040000 00020000 "NAND.u-boot-spl-os"
mtd5: 00100000 00020000 "NAND.u-boot"
mtd6: 00020000 00020000 "NAND.u-boot-env"
mtd7: 00020000 00020000 "NAND.u-boot-env.backup1"
mtd8: 00800000 00020000 "NAND.kernel"
mtd9: 0d600000 00020000 "NAND.rootfs"
mtd10: 02000000 00020000 "NAND.userdata"
```
找到kernel分区对应的dev
```
flash_eraseall /dev/mtd8
或者
flash_erase /dev/mtd8 0 0

nandwrite -p /dev/mtd8 zImage
```

## uboot中更新kernel
查看分区表
```
mtdparts
```
```
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
10: NAND.userdata       0x02000000      0x0e000000      0
```
切换到sd卡, 确保sd里面有kernel镜像文件
```
mmc dev 0
```
从sd卡加载zimage到内存
```
fatload mmc 0 88880000 zimage
```
擦除并写入
```
nand erase.part NAND.kernel
nand write 88880000 NAND.kernel
```
强制清除坏块表
nand scrub 