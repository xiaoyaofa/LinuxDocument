## 驱动
git clone https://github.com/STMicroelectronics/gcnano-binaries -b  gcnano-6.4.15-binaries
git checkout bbaae49a0e4859ed53f898a250269c8a237261bc

编译
```
export KERNEL_DIR="/home/xie/Source/LD25X/SDK1.1/MYD-LD25X-Linux-L6.1.82-V1.1.0/myir-st-linux"
export GPU_DRIVER_DIR="/home/xie/Source/LD25X/SDK1.1/modules/gpu/gcnano-binaries/gcnano-driver-stm32mp/"
make SOC_PLATFORM=st-mp2 -C $KERNEL_DIR M=$GPU_DRIVER_DIR AQROOT=$GPU_DRIVER_DIR -j
```