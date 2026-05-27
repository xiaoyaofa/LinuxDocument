## optee clk崩溃
etnaviv GPU驱动导致的，257用的galcore.ko
解决方法: 参考yocto系统，添加模块黑名单
```
root@myd-ld25x:/etc/modprobe.d# ls
blacklist.conf	stm32mp1-snd.conf  usbip.conf
root@myd-ld25x:/etc/modprobe.d# cat *
blacklist etnaviv
softdep snd-soc-cs42l51 pre: snd-soc-cs42l51-i2c
blacklist usbip-core
blacklist usbip-host
```