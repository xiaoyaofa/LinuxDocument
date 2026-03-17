## 常用
列出可用的CEC设备
cec-ctl --list-devices

监控CEC总线上的流量
cec-ctl -d 0 -m

## 配置适配器设备类型
自动从EDID设置物理地址
```
cec-ctl -d 0 -e /sys/class/drm/card1-HDMI-A-1/edid --tv
```
手动设置物理地址
```
cec-ctl -d 0 --tv -o "My TV" -p 1.0.0.0
```
清除现有配置
```
cec-ctl -d 0 -C
```

## 发送命令
cec-ctl -d 0 --to 0 --standby