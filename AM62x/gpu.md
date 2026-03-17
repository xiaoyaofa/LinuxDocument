## lib
git clone https://git.ti.com/git/graphics/omap5-sgx-ddk-um-linux.git  -b ti-img-sgx/kirkstone-mesa/1.17.4948957

## modules
pvrsrvkm.ko

git clone https://git.ti.com/git/graphics/ti-img-rogue-driver.git -b linuxws/kirkstone/k6.1/23.1.6404501

export PVR_BUILD_DIR=am62_linux
make -j CC="$CC" KERNELDIR=xxx