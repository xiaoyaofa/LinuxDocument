## 常用命令
根据bsp创建工程
```
petalinux-create -t project -s myir-c7z010-image-full.bsp
```
配置工程
```
petalinux-config
```
总体编译
```
petalinux-build
```
打包成BOOT.BIN、image.ub
```
petalinux-package --boot --fpga --u-boot --force
```

### 创建自定义项目
```
petalinux-create project --template zynq --name MYD-C7Z020-test
```
配置使用的xsa(fpga侧生成的文件)
```
petalinux-config --get-hw-description=../design_1_wrapper_c7z020.xsa
```
### 打包bsp
```
petalinux-package bsp -p ~/Petalinux/MYD-C7Z020 --output MYC-C7Z020.bsp
```
### Uboot
```
petalinux-build -c u-boot -x cleansstate
petalinux-build -c u-boot
```
### Kernel
```
petalinux-build -c kernel -x menuconfig
petalinux-build -c kernel -x cleansstate
petalinux-build -c kernel
```
### dtb
```
petalinux-build -c device-tree -x cleansstate;
petalinux-build -c device-tree
```

###  制作wic(petalinux2020之后支持)
```
petalinux-package --wic --bootfiles "BOOT.BIN boot.scr image.ub rootfs.tar.gz"
```

## 设备树参考和修改位置
### 参考位置
以下设备树是根据xsa文件自动生成的设备树，不可修改

pl.dtsi：该文件中包含了所有可用的内存映射的PL IP节点。
```
components/plnx_workspace/device-tree/device-tree/pl.dtsi
```

pcw.dtsi：包含PS外设所需的动态属性，包含我们在FPGA工程创建时，在原理框图设计中进行IO配置的外设接口。
```
components/plnx_workspace/device-tree/device-tree/pcw.dtsi
```

system-top.dts：该文件以include的方式包含了pcw.dtsi和zynq-7000.dtsi，包含内存信息和早期控制台和启动参数。
```
components/plnx_workspace/device-tree/device-tree/system-top.dtsi
```

zynqmp.dtsi：包含了所有的PS外设信息以及CPU信息。
```
components/plnx_workspace/device-tree/device-tree/zynqmp.dtsi
```
### 修改设备树
system-user.dtsi是可以自定义的设备树，在这里面的修改可以覆盖上面的设备树
```
project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi
```