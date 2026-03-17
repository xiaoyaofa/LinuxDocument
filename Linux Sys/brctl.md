创建一个名为 name 的桥接网络接口
```
brctl addbr xxx
```
删除
```
brctl delbr xxx
```
把一个物理接口 ifname 加入桥接接口 brname 中，所有从 ifname 收到的帧都将被 brname 处理
```
brctl addif <brname> <ifname>
```