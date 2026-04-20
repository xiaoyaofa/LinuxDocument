### 内核配置
```
CONFIG_USB_ETH=m
CONFIG_USB_FUNCTIONFS=m
```
### 使用
```
modprobe g_ether
```
如果win11检测不到虚拟网口，需要安装mod-rndis-driver-windows驱动