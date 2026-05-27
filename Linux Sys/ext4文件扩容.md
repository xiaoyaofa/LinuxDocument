## 扩容
扩容到8G
```
truncate -s 8G xxx.rootfs.ext4
```
修改文件系统
```
e2fsck -f xxx.rootfs.ext4
```
重新拓展大小
```
resize2fs -f xxx.rootfs.ext4
```