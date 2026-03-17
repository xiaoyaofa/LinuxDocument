### 关闭Linux打印
```
vi /etc/inittab
```
找到下面这行注释
tty1:12345:respawn:/sbin/getty 38400 tty1

```
vi /etc/init.d/banner.sh
```
注释

```
cd /etc/init.d
rm populate-openeuler-volatile.sh
rm populate-volatile.sh
```