## 网络时间同步
vi /etc/systemd/timesyncd.conf
```
···
[Time]
NTP=ntp.ntsc.ac.cn ntp.aliyun.com ntp.tencent.com
FallbackNTP=cn.pool.ntp.org cn.ntp.org.cn
···
```
systemctl restart systemd-timesyncd
输入 date 查看时间是否成功更新，同步时间可能几分钟到十几分钟不等

## 时区问题
查看运行状态
timedatectl
查看时区表
timedatectl list-timezones
设置上海时区
timedatectl set-timezone Asia/Shanghai