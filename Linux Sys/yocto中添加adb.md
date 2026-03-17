## yocto添加包
```
IMAGE_INSTALL += " android-tools libbsd libmd"
```
## 内核配置
```
CONFIG_USB_GADGET=y
```
## 文件系统
手动运行
```
/usr/bin/android-gadget-setup
/usr/bin/adbd &
/usr/bin/android-gadget-start
```
服务运行
```
mkdir /var/usb-debugging-enabled
```
```
systemctl start android-tools-adbd
```
## 清除
```
killall adbd
/usr/bin/android-gadget-cleanup
```
或者
```
systemctl stop android-tools-adbd
```

## 自启动
修改/lib/systemd/system/android-tools-adbd.service
添加一行After=getty@tty1.service
```
[Unit]
Description=Android Debug Bridge
ConditionPathExists=/var/usb-debugging-enabled
After=getty@tty1.service
Before=android-system.service
```
