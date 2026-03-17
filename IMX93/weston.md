export WAYLAND_DISPLAY=/run/wayland-0
或者
vi /etc/profile.d/weston-socket.sh
```
开头加export WAYLAND_DISPLAY=/run/wayland-0
```

systemctl start weston
触摸问题
weston-calibrator /dev/input/by-path/platform-44350000.i2c-event
