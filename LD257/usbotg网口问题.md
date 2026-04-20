/etc/udev/rules.d/99-usb-eth.rules
```
ACTION=="remove", SUBSYSTEM=="udc", KERNEL=="48300000.usb", ENV{USB_UDC_DRIVER}=="g1",RUN+="/usr/sbin/stm32_usbotg_eth_config.sh stop"
ACTION=="add", SUBSYSTEM=="udc", KERNEL=="48300000.usb" ,RUN+="/usr/sbin/stm32_usbotg_eth_config.sh start"
```