ifconfig uap0 192.168.10.1 up
## udhcpd
vi /etc/my_udhcpd.conf
```
# the start and end of the IP lease block
start 192.168.10.10
end 192.168.10.254
# the interface that udhcpd will use
interface uap0
opt dns 8.8.8.8
option subnet 255.255.255.0
opt router 192.168.10.1
option domain local
option lease 864000
```
udhcpd /etc/my_udhcpd.conf

## 配置如下报错
/etc/my_hostapd.conf
```
interface=uap0
driver=nl80211
#mode Wi-Fi (a = IEEE 802.11a, b = IEEE 802.11b, g = IEEE 802.11g)
hw_mode=a
#country_code=CN
ssid=MYIR_TEST
#freqlist=5180-5825
channel=149
wmm_enabled=0
macaddr_acl=0
# Wi-Fi closed, need an authentication
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=myir2020
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
```
报错
```
uap0: IEEE 802.11 Configured channel (44) or frequency (5220) (secondary_channel=0) not found from the channel list of the current mode (2) IEEE 802.11a
```

iw list查看发现5G频率全部无法使用
```
Frequencies:
* 5180 MHz [36] (20.0 dBm) (no IR)
* 5200 MHz [40] (20.0 dBm) (no IR)
* 5220 MHz [44] (20.0 dBm) (no IR)
* 5240 MHz [48] (20.0 dBm) (no IR)
* 5260 MHz [52] (20.0 dBm) (no IR, radar detection)
* 5280 MHz [56] (20.0 dBm) (no IR, radar detection)
* 5300 MHz [60] (20.0 dBm) (no IR, radar detection)
* 5320 MHz [64] (20.0 dBm) (no IR, radar detection)
* 5500 MHz [100] (20.0 dBm) (no IR, radar detection)
* 5520 MHz [104] (20.0 dBm) (no IR, radar detection)
* 5540 MHz [108] (20.0 dBm) (no IR, radar detection)
* 5560 MHz [112] (20.0 dBm) (no IR, radar detection)
* 5580 MHz [116] (20.0 dBm) (no IR, radar detection)
* 5600 MHz [120] (20.0 dBm) (no IR, radar detection)
* 5620 MHz [124] (20.0 dBm) (no IR, radar detection)
* 5640 MHz [128] (20.0 dBm) (no IR, radar detection)
* 5660 MHz [132] (20.0 dBm) (no IR, radar detection)
* 5680 MHz [136] (20.0 dBm) (no IR, radar detection)
* 5700 MHz [140] (20.0 dBm) (no IR, radar detection)
* 5720 MHz [144] (20.0 dBm) (no IR, radar detection)
* 5745 MHz [149] (20.0 dBm) (no IR)
* 5765 MHz [153] (20.0 dBm) (no IR)
* 5785 MHz [157] (20.0 dBm) (no IR)
* 5805 MHz [161] (20.0 dBm) (no IR)
* 5825 MHz [165] (20.0 dBm) (no IR)
* 5845 MHz [169] (disabled)
* 5865 MHz [173] (disabled)
* 5885 MHz [177] (disabled)
```

## 运行时加入调试打印
hostapd /etc/my_hostapd.conf -d
发现country code为00，不是CN

## 解决
/etc/my_hostapd.conf加入配置
```
country_code=CN
```
或者
iw reg set CN
iw reg get
```
global
country CN: DFS-FCC
        (2400 - 2483 @ 40), (N/A, 20), (N/A)
        (5150 - 5350 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW
        (5725 - 5850 @ 80), (N/A, 33), (N/A)
        (57240 - 59400 @ 2160), (N/A, 28), (N/A)
        (59400 - 63720 @ 2160), (N/A, 44), (N/A)
        (63720 - 65880 @ 2160), (N/A, 28), (N/A)
```

hostapd -B /etc/my_hostapd.conf