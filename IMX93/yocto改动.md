sources/meta-myir/meta-bsp/recipes-bsp/u-boot/u-boot-imx-common_2023.04.inc
```
SRCBRANCH = "develop_2023.04"
UBOOT_SRC ?= "git://github.com/MYiR-Dev/myir-imx-uboot.git;protocol=https"
```
sources/meta-myir/meta-bsp/recipes-kernel/linux/linux-imx_6.1.bb
```
KERNEL_SRC ?= "git://github.com/MYiR-Dev/myir-imx-linux.git;protocol=file;branch=${SRCBRANCH}"
SRCBRANCH = "develop_6.1.55"
```