## 网络接口配置
/etc/config/network

动态ip
```
config interface 'wan'
        option device 'eth1'
        option proto 'dhcp'
```
静态ip
```
config interface 'wan'
        option device 'eth0' 
        option proto 'static'
        option ipaddr '192.168.1.20'
        option netmask '255.255.255.0'
```

## 网络服务配置
/etc/config/dhcp

## 防火墙配置
/etc/config/firewall

## uci
查看网络配置
uci show network

配置动态获取
uci set network.lan.proto=dhcp

设置IP配置方式
uci set network.lan.proto='static'

设置LAN口的IP地址
uci set network.lan.ipaddr='192.168.10.100'

保存修改后的配置
uci commit network

重启网络服务生效
/etc/init.d/network reload