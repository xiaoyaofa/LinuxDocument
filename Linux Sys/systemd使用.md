## 服务配置
模板
在/lib/systemd/system/下添加一个服务xxx.service
```
[Unit]
Description=service
After=weston.service

[Service]
Type=simple
ExecStart=xxx

[Install]
WantedBy=multi-user.target
```
Description 描述
After 在什么服务之后
ExecStart 开机执行的命令
ExecStartPre 执行的命令前，执行什么命令(ExecStartPre=/bin/sleep 10)
ExecStop 服务停止时执行
ExecStopPost 服务停止后再执行
StandardOutput=tty 输出到串口
TimeoutStartSec 服务超时等待时间(infinity 为无限)
Environment="USER=root" 环境变量
Type
```
simple forking oneshot dbus notify
```
User
Restart 重启
```
always 无条件重启
on-failure 智能重启
```
RestartSec 多久后重启
RemainAfterExit
```
yes 只会负责启动服务进程，之后即便服务进程退出了
no
```
KillMode
```
control-group: 终止该单元的所有进程
mixed: 发送 SIGTERM 信号给主进程，然后发送 SIGKILL 信号给剩余进程。
process: 仅终止主进程
none: 不终止任何进程
```
### 描述
开始服务
systemctl start test
停止服务
systemctl stop test
开启自启服务
systemctl enable test
关闭自启服务
systemctl disable test
服务状态
systemctl status test
重新载入服务配置
systemctl daemon-reload
查看活跃的服务
systemctl list-units --type=service --state=active
查看运行中的服务
systemctl list-units --type=service --state=running
## 自启分析
查看所有开机自启的服务
```
systemctl list-unit-files --state=enabled
```
查看服务的初始化时间
```
systemd-analyze blame
```
查看启动花费时间
```
systemd-analyze time
```
查看还有哪些服务未启动
```
systemctl list-jobs
```
查看依赖
```
systemctl list-dependencies
```
查看反向依赖
```
systemctl list-dependencies --reverse emptty.service
```

## systemd-sysv

/lib/systemd/system-generators/systemd-sysv-generator
用于自动转换老的sysv(/etc/init.d)到/run/systemd/generator.late

```
systemd-sysv-install
Usage: /lib/systemd/systemd-sysv-install [--root=path] enable|disable|is-enabled <sysv script name>
```

举例要修改systemd-sysv自动生成的dropbear服务配置
通过override覆盖原来的配置
vi /etc/systemd/system/dropbear.service.d/override.conf
```
[Service]
Restart=always
RestartSec=60s
RemainAfterExit=no
```
这个设置会覆盖原本的服务配置
systemctl daemon-reload

## 查看日志

journalctl -u test.service -f
journalctl -f

journalctl --since "2025-10-14" --until "2025-10-15"

## 清空日志
删除多久之前的日志
journalctl --vacuum-time=7d

rm -rf /var/log/journal/*

## 持久化日志
创建日志目录
mkdir -p /var/log/journal
查看/var/log是否是链接到volatile/log
有的话删除，创建真实的 /var/log 目录

修改/etc/systemd/journald.conf
```
[Journal]
Storage=persistent
```
限制日志文件大小
SystemMaxUse是限制所有日志总占空间大小，SystemMaxFileSize是限制单个轮转日志文件的大小
```
SystemMaxUse=500M
```
重新启动服务
systemctl restart systemd-journald


## 分页打印

临时
添加 --no-pager 参数
永久
vi /etc/environment
```
SYSTEMD_PAGER=cat
```

## 重载配置文件
systemctl daemon-reload

systemctl stop avahi-daemon ntpd rpcbind rpcbind.socket  nfs-server.service nfs-mountd.service nfs-statd.service bluetooth iptables ip6tables proftpd swupdate swupdate.socket connman sshd.socket parsec systemd-resolved systemd-timesyncd

## 加载模块
systemctl status systemd-modules-load

## 网络时间同步
配置文件
/etc/systemd/timesyncd.conf
添加NTP网站
```
NTP=ntp1.aliyun.com ntp.neu.edu.cn
```

systemctl restart systemd-timesyncd.service

## watchdog
配置/etc/systemd/system.conf

```
[Manager]
RuntimeWatchdogSec=30s
RebootWatchdogSec=10min
KExecWatchdogSec=5min
```
- **RuntimeWatchdogSec**: 配置运行时的硬件看门狗超时时间。如果在指定时间内没有收到心跳信号，系统将自动重启。
- **RebootWatchdogSec**: 配置系统重启时的看门狗超时时间。用于确保在重启过程中，如果系统无法正常重启，看门狗会强制重启系统。
- **KExecWatchdogSec**: 配置 kexec 执行时的看门狗超时时间。kexec 是一种快速重启技术，允许直接从当前内核启动新内核。