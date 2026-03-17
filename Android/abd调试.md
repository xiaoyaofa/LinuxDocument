## 常用命令
查看已连接设备列表
```
adb devices -l
```
进入默认设备shell
```
adb shell
```
进入指定设备shell
```
adb -s <设备序列号> shell
```

## 文件传输
```
adb push <文件> <目标目录>
```
