检查FORWARD链
```
iptables -L -v -n --line-numbers
```
检查NAT规则
```
iptables -t nat -L -v -n
```
删除所有规则
```
iptables -F
iptables -t nat -F
```
删除指定规则
```
iptables -D <INPUT/FORWARD/OUTPUT> <规则编号>
```