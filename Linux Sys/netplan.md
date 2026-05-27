## 动态配置

```
network:
    version: 2
    ethernets:
        eth0:
            dhcp4: yes
            dhcp4-overrides:
                route-metric: 100
        eth1:
            dhcp4: yes
            dhcp4-overrides:
                route-metric: 200
```

## 静态配置

```
network:
    version: 2
    ethernets:
        eth0:
            dhcp4: no
            addresses:
                - 192.168.1.100/24
            routes:
                - to: default
                  via: 192.168.1.1
            nameservers:
                addresses:
                    - 8.8.8.8
        eth1:
            dhcp4: no
            addresses:
                - 192.168.2.100/24
            routes:
                - to: default
                  via: 192.168.2.1
            nameservers:
                addresses:
                    - 8.8.8.8
```
