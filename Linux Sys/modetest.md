## 查看drm设备
ls /dev/dri/
cat /sys/class/drm/card0/device/uevent
modetest -D /dev/dri/card0
## 测试
-M可以指定模块，其中32是Connectors ID，44是CRTC ID，1920x1080是分辨率
```
modetest -M stm -s 32@44:1920x1080
```
索引
modetest -M tidss -s 50@48:#9