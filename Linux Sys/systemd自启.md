在/lib/systemd/system/下添加一个服务
```
[Unit]
Description=service
After=weston.service

[Service]
Type=simple
ExecStart=/home/root/test -platform eglfs

[Install]
WantedBy=multi-user.target
```
开启自启服务
systemctl enable test
关闭自启服务
systemctl disable test
## 串口服务冲突
有服务与自己串口程序冲突，导致自启动串口应用读不到数据
修改
```
After=multi-user.target
WantedBy=getty.target
```
如果还有冲突，可以延迟执行
ExecStart=/home/root/start.sh
vi /home/root/start.sh
```
#!/bin/bash
/bin/sleep 3 
/home/root/ucure2UI-rx --platform linuxfb
```
或者
stty -F /dev/ttymxc3 115200 cs8 -cstopb -parenb