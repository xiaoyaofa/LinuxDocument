你可以使用ubuntu的networkmanger
你板子先手动连上网
```
sudo apt update
sudo apt install network-manager wpasupplicant wireless-tools netplan.io xterm
```
扫描当前可用的无线网路
```
sudo iwlist wlan0 scan | grep -E "Quality|ESSID"
```
```
sudo vim /etc/netplan/orangepi-default.yaml
```
```
其中yaml文件配置wifi如下
network:
    version: 2
    renderer: NetworkManager
    wifis:
        wlan0:
            dhcp4: true
            access-points:
                "你的wifi名字":
                password: "你的wifi密码"
```

network:
    version: 2
    renderer: NetworkManager
    wifis:
        wlan0:
            dhcp4: true
            access-points:
                "myir_test":
                password: "12345678"

```
sudo netplan apply
```
### 参考链接
```
https://blog.csdn.net/meihualing/article/details/133953167?ops_request_misc=&request_id=&biz_id=102&utm_term=ubuntu%20networkmanager%E8%87%AA%E5%90%AF%E5%8A%A8wifi&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-0-133953167.142^v100^pc_search_result_base4&spm=1018.2226.3001.4187
```