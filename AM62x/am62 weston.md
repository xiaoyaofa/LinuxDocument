## 取消自启weston
systemctl disable weston
rm /etc/systemd/system/ti-apps-launcher.service
## weston-launch-calibrator自启
/etc/xdg/weston/weston.ini
```
#path=/usr/bin/weston-launch-calibrator
```