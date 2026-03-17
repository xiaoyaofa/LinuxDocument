## 回环测试
配置eth0 和 eth1
```
ifconfig eth0 192.168.10.1 netmask 255.255.255.0 up
ifconfig eth1 192.168.20.1 netmask 255.255.255.0 up
```
添加路由
```
ip route add 192.168.20.0/24 dev eth0
ip route add 192.168.10.0/24 dev eth1
```
开启iperf3服务端
```
iperf3 -s &
```
测试
```
iperf3 -c 192.168.10.1 -B 192.168.20.1 -t 10
```

```

```
### 走物理网线而不是系统内部
同一个板子 eth0 <--> eth1
创建网络命名空间
````
ip netns add n1
ip netns add n2
```

```
ip link set eth1 netns n1
ip link set eth2 netns n2
```

```
ip netns exec n1 ifconfig eth1 192.168.10.2
ip netns exec n1 ifconfig
ip netns exec n2 ifconfig eth2 192.168.10.3
ip netns exec n2 ifconfig
```

```
ip netns exec n2 ping 192.168.10.2
```
```
ip netns exec n2 iperf3 -s &
ip netns exec n1 iperf3 -c 192.168.10.3 -t 10 -b 1000M
```