查看蓝牙设备，SDIO的可以直接看见节点
```
hciconfig
```
连接到串口蓝牙
```
hciattach /dev/ttyS3 any 115200 flow
```
## bluetoothctl
使能蓝牙电源
```
power on
```
管理并查看代理管理是否成功
```
agent on
```
默认代理
```
default-agent
```
可被发现
```
discoverable on
```
可配对 
```
pairable on
```
广播
```
advertise on
```
扫描
```
scan on
```
设备配对
```
pair xxx
```
连接
```
connect xxx
```
查看当前匹配的设备
```
devices [Paired/Bonded/Trusted/Connected]
```
取消信任设备
```
untrust xxx
```
取消配对
```
remove xxx
```

传输文件测试
```
bt-obex -p 28:59:23:CC:BC:30 ./test.txt
```
设置本机蓝牙名字
```
system-alias <name>
```
设置其他蓝牙名字
```
set-alias <name>
```

### BLE
只扫描ble设备
```
scan le on
```
测试ble时，手机使用nRF Connect软件和linux开发板的蓝牙连接
在bluetoothctl连接后
切换到gatt
```
menu gatt
```



## btmgmt

## 调试发送接收的命令
hcidump