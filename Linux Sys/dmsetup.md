## 列出所有映射卷
```
dmsetup ls
```
查看详细内容
```
dmsetup info
```
查看节点是否存在
```
ls -l /dev/mapper/mytest
```
## 删除卷
```
dmsetup remove mytest
```
如果卷是基于loop的，要释放loop
```
losetup -a
losetup -d /dev/loopx
```
