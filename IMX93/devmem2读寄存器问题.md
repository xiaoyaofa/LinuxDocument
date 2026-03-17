以i2c寄存器举例
强制供电，不进入suspend状态
```
echo on > /sys/devices/platform/soc\@0/44000000.bus/44340000.i2c/power/control
```