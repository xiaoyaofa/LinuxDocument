## 配置
全局配置文件 /etc/systemd/networkd.conf 只能用于覆盖某些默认设置，主要配置是针对每个网络设备进行的。
配置文件位于 /usr/lib/systemd/network/
易失性运行时网络目录 /run/systemd/network/ 
和本地管理网络目录 /etc/systemd/network/
/etc/systemd/network/ 中的文件具有最高优先级

## 静态ip
vi /etc/systemd/network/10-eth0-static.network
```
[Match]
Name=eth0
[Network]
Address=192.168.1.100/24
Gateway=192.168.1.1
#DHCP=yes
#Unmanaged=yes
[Route]
#Destination=0.0.0.0/24
#Metrics=100
#[DHCP]
#UseDNS=true
#UseRoutes=true
#[Link]
#MACAddress=00:11:22:33:44:55
#[DHCPv4]
#RouteMetric=100
#UseDomains=true
#DNSDefaultRoute=false
```
systemctl restart systemd-networkd

DNS配置
systemctl start systemd-resolved
然后看看有没有链接
ls /etc/resolv*
没有需要链接一下
ln -s /etc/resolv-conf.systemd /etc/resolv.conf

## networkctl
networkctl用于和systemd-networkd配合使用，用于控制网络

概览所有网络接口
```
networkctl list
```
查看某个网卡详细信息
```
networkctl status eth0 --no-page
```
重新加载配置文件
```
networkctl reload
```
重新协商某个网卡
```
networkctl reconfigure eth0
```
启用/禁用网卡
```
networkctl up eth0
networkctl down eth0
```