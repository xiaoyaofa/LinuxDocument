vi /etc/network/interfaces
```
auto eth1
iface eth1 inet static
address 192.168.2.10
netmask 255.255.255.0
gateway 192.168.2.1
```
systemctl restart networking