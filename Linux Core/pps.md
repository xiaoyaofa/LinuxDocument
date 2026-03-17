时间源一般是来自GPRMC+PPS的信号组合
## PPS GPIO
设备树配置参考
Documentation/devicetree/bindings/pps/pps-gpio.txt
## PPS GPRMC
GPRMC一般是uart信号
确定有加载pps_ldisc，然后执行下面的命令生成/dev/pps节点
```
ldattach PPS /dev/ttyxxx
```
使用pps-tools软件包里面的ppstest测试
```
ppstest /dev/pps1
```
## 时间同步
使用gpsd + chrony + pps进行时间同步

## 参考
https://zhuanlan.zhihu.com/p/607137505
https://blog.csdn.net/TSZ0000/article/details/131226209