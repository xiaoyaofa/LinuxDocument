git clone https://bgithub.xyz/eembc/coremark.git
这里以ld257为例
mkdir stm32mp257
mkdir stm32mp257_posix
cp linux/* stm32mp257
cp posix/* stm32mp257_posix
make PORT_DIR=stm32mp257 compile -j
生成coremark.exe

修改优化参数
vi stm32mp257_posix/core_portme.mak
```
PORT_CFLAGS = -O3
```
修改迭代次数可以通过传参改
可以查看README.md文档
./coremark.exe  0x0 0x0 0x66 120000 7 1 2000