### uboot添加启动参数
将CPU1与内核调度使用隔离开
```
setenv optargs isolcpus=1
```
或者在bootargs添加isolcpus=1

dmesg | grep isol 看看有没有添加成功
### 程序运行到指定内核 
```
taskset --cpu-list <core num> <app>
```