### 开启串口唤醒
```
echo enabled > /sys/devices/platform/soc/1004b800.serial/tty/ttySC0/power/wakeup
```

### 禁用休眠
```
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```