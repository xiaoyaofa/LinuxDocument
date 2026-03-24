Binwalk 是一个专门用于固件分析和文件提取的工具
## 基本命令结构

基本扫描
```
binwalk firmware.bin
```

提取文件
```
binwalk -e firmware.bin
```
dd手动提取，skip用binwalk扫描出来的偏移量
```
dd if=firmware.bin of=test skip=xxx bs=1
```
递归提取
```
binwalk -Me firmware.bin
```