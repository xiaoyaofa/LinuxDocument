## 切换HOST模式
```
echo host > /sys/devices/platform/soc/11c50200.usb-phy/role
```
## 切换从模式
```
echo peripheral > /sys/devices/platform/soc/11c50200.usb-phy/role
```

## 配置USB OTG虚拟串口
```
Device Drivers  --->
    [*] USB support  --->
        <*>   USB Modem (CDC ACM) support
        <*>   USB Gadget Support  --->
            [*]   Serial gadget console support 
            <M>   USB Gadget functions configurable through configfs
            USB Gadget precomposed configurations  --->
                <M> Serial Gadget (with CDC ACM and CDC OBEX support) 
```
```
insmod libcomposite.ko
insmod u_serial.ko
insmod usb_f_serial.ko
insmod usb_f_acm.ko
insmod g_serial.ko
```
显示如下后，驱动加载完成
```
g_serial gadget: Gadget Serial v2.4
g_serial gadget: g_serial ready
```
### windows安装驱动
在内核目录在找到驱动文件
Documentation/usb/linux-cdc-acm.inf
关闭windows驱动签名
```
设置->恢复->高级启动->疑难解答->高级选项->启动选项->重启->禁用驱动程序强制签名
```
在windows右键安装linux-cdc-acm.inf

### 测试虚拟串口
板子向电脑发送消息
```
echo "hello" > /dev/ttyGS0
```
测试电脑向板子发送消息(电脑会自发自收)
```
cat /dev/ttyGS0
```
然后用串口工具发送消息即可