## 挂载
```
mkdir temprootfs
sudo kpartx -av xxx.wic
add map loop15p1 (253:0): 0 170392 linear 7:15 16384
add map loop15p2 (253:1): 0 12997332 linear 7:15 196608
```
```
sudo mount /dev/mapper/loop15p2 temprootfs/
ls temprootfs
```
## 卸载
```
sudo umount temprootfs/
```
如果系统自动挂载还需要输入如下
```
sudo umount /media/user/xxx
```
```
sudo kpartx -d xxx.wic
sudo kpartx -dv /dev/loop15
```

ext4文件挂载过后，执行一下
e2fsck -f xxx.ext4