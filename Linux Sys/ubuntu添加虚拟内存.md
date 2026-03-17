## 配置
创建交换空间
```
sudo fallocate -l 2G /swapfile1
```
设置权限：
```
sudo chmod 600 /swapfile1
```
配置交换空间
```
sudo mkswap /swapfile1
```
验证交换空间：
```
sudo swapon /swapfile1
```
/etc/fstab 配置永久启用交换文件
最后一行添加：
```
/swapfile1 none swap sw 0 0
```
编辑/etc/sysctl.conf改变交换空间的占比
```
vm.swappiness=10
```
应用更改
```
sudo sysctl -p
```
## 删除
停止
```
swapoff /swapfile1
```
删除swap分区文件
```
rm /swapfile1
```
删除或注释/etc/fstab文件中的以下开机自动挂载内容
```
/swapfile none swap sw 0 0
```
原文链接
https://blog.csdn.net/liusomes/article/details/140632120

## 清除交换空间缓存
```
swapoff -a && swapon -a
```