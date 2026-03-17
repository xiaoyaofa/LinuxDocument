## VMware17
### 修改VMWare的vmx文件：
文件在虚拟系统文件夹下×.vmx文件，添加以下语句：
```
mouse.vusb.enable = "TRUE"
mouse.vusb.useBasicMouse = "FALSE"
usb.generic.allowHID = "TRUE"
```