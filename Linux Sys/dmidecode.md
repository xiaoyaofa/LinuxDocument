## 介绍
Linux 系统中用于解析 ​​DMI（Desktop Management Interface）​​ 数据库的命令行工具，能够以可读格式输出硬件详细信息（如 BIOS、主板、CPU、内存等）

## 读内存信息
```
dmidecode -t memory
```

## 读CPU信息
```
dmidecode -t processor
```

## 读BIOS信息
```
dmidecode -t bios
```