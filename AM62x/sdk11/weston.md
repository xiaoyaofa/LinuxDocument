配置
/usr/share/wayland-sessions/weston.desktop
新sdk，改用emptty.service，这是一个轻量化显示管理器
启动weston
```
systemctl start emptty
```
停止weston
```
systemctl stop emptty
```
关闭自启动
```
systemctl disable emptty
systemctl disable run_hmi
systemctl disable seva-launcher
```
export WAYLAND_DISPLAY=/run/user/1000/wayland-1
