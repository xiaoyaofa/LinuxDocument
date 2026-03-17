## 执行insmod时，出现如下错误
```
#insmode test.ko
code: version magic '······' should be '······' insmod: can’t insert ‘test.ko’: invalidmodule format
```

进入linux内核源码，找到
```
vi include/linux/vermagic.h
```
在vermagic.h中会包含一个头文件，进入该头文件，查看版本
utsrelease.h是由Makefile和.config生成的文件
```
vi include/generated/utsrelease.h
```
vi include/generated/compile.h
生成compile.h的脚本
vi scripts/mkcompile_h
## 解决方法
修改.config，CONFIG_LOCALVERSION为修改的名字
```
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=n
```
去掉+号
make时添加LOCALVERSION并设为空
make LOCALVERSION="" Image -j16

前面的内核版本号在顶层的Makefile中定义
```
VERSION = 5
PATCHLEVEL = 10
SUBLEVEL = 83
```