## nmcli
查看设备状态
nmcli device status
查看已连接的网卡信息(不显示虚拟设备)
nmcli connection show
修改属性
nmcli device modify <设备名> \
  ipv4.method manual \
  ipv4.addresses <IP/掩码> \
  ipv4.gateway <网关> \
  ipv4.dns "<DNS服务器>"
重新加载配置文件
nmcli connection reload

## WIFI
### STA
nmcli dev wifi list
nmcli -t dev wifi connect my_test password 971384625

nmcli device disconnect wlan0
### AP
创建热点，以后如果要使用，可以直接nmcli connection up ap001
nmcli device wifi hotspot con-name ap001 ifname wlan0 ssid myAP001 password 12345678
### 关闭控制
nmcli device set wlan0 managed no

## 配置ip
### 图形化配置
nmtui

网卡配置文件位置
vi /etc/NetworkManager/system-connections/eth1.nmconnection
```
[connection]
id=eth1
uuid=d51bcd2d-3f2e-3ad7-8eb7-8af54c7a89f5
type=ethernet
autoconnect-priority=-999
interface-name=eth1

[ethernet]

[ipv4]
address1=192.168.1.20/24,192.168.1.1
dns=144.144.144.144;8.8.8.8;
method=manual

[ipv6]
addr-gen-mode=default
method=auto

[proxy]
```

### 忽略管理网口
临时
nmcli dev set eth1 managed no 

永久
vi /etc/NetworkManager/NetworkManager.conf
添加
```
[keyfile]
unmanaged-devices=interface-name:eth1
```
systemctl restart NetworkManager
