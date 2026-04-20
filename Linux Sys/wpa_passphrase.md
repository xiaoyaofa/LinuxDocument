通过systemd服务配置
xxx对应wifi网卡名字
```
cp /etc/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-mlan0.conf
wpa_passphrase MYIR myir.tech >> /etc/wpa_supplicant/wpa_supplicant-xxx.conf
```
启动服务
```
systemctl start wpa_supplicant@xxx
```


wpa_passphrase MYIR myir.tech >> /etc/wpa_supplicant/wpa_supplicant-mlan0.conf