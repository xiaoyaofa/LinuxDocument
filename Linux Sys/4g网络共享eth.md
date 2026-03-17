## 主机端
### 启用 IP 转发
sysctl -w net.ipv4.ip_forward=1

### 清除旧规则
iptables -F
iptables -t nat -F

### 允许已建立的连接和回环接口
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i lo -j ACCEPT

### 设置 NAT 规则：将来自 eth1 的流量通过 wwan0 转发
iptables -t nat -A POSTROUTING -o wwan0 -j MASQUERADE

### 允许从 eth1 到 wwan0 的转发
iptables -A FORWARD -i eth1 -o wwan0 -j ACCEPT

## 客户端
### 添加网关(主机端eth的ip)
ip route add default via 192.168.1.xxx

## 主机配置DNS服务器
/etc/dnsmasq.conf
```
interface=eth1                # 监听 eth1 接口
dhcp-range=192.168.1.100,192.168.1.200,255.255.255.0,24h  # 分配的 IP 范围
dhcp-option=option:router,192.168.1.1     # 网关地址（eth1 的 IP）
dhcp-option=option:dns-server,8.8.8.8     # DNS 服务器
#no-daemon                                   # 前台运行（调试时使用）
```
iptables -A INPUT -i eth1 -p udp --dport 67:68 --sport 67:68 -j ACCEPT
iptables -A OUTPUT -o eth1 -p udp --dport 67:68 --sport 67:68 -j ACCEPT

