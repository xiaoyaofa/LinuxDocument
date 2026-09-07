## 强制复位usb

ci_hdrc是usb控制器的名字，不同平台名字不一样
```
echo ci_hdrc.1 > /sys/bus/platform/drivers/ci_hdrc/unbind
sleep 0.5
echo ci_hdrc.1 > /sys/bus/platform/drivers/ci_hdrc/bind
```