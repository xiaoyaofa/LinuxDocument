drivers/net/phy/phy_device.c

添加phy addr打印和强制指定phy id
static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
```
	pr_err("get_phy_c22_id|===id:%s, addr:%d, phyid=%08x\r\n", bus->id, addr, *phy_id);

    if((0x1d == addr)&&(strcmp(bus->id,"stmmac-0") == 0))
	{
		pr_err("phy_id=0x9215 === bus->id %s \r\n", bus->id);
		*phy_id = 0x9215;
	}
```

## 本地回环测试
本地回环一般用于检测mac和phy直接的通信情况
禁用自协商
ethtool -s eth0 speed 1000 duplex full autoneg off
使用phytool工具写phy的寄存器，开启回环模式
1000M回环一般都是0x0寄存器写0x4140
100M回环一般都是0x0寄存器写0x6100
```
./phytool write eth0/0x0/0x0 0x4140
./phytool read eth0/0x0/0x0
```
设置本机静态ip
ifconfig eth0 10.3.3.1
用本机mac地址虚拟远端IP（同网段）建立MAC映射
```
arp -s 10.3.3.2 3A:69:D0:D9:80:0A
```
或者
```
ip neigh add 10.3.3.2 lladdr 3A:69:D0:D9:80:0A dev eth0 nud permanent
```
抓包
```
tcpdump -i eth0 host 10.3.3.2 &
```
```
ping 10.3.3.2 -c 1
```
回环通的话能抓到2个包


ethtool -s eth1 speed 1000 duplex full autoneg off
使用phytool工具写phy的寄存器，开启回环模式
1000M回环一般都是0x0寄存器写0x4140
```
./phytool write eth1/0x0/0x0 0x4140
./phytool read eth1/0x0/0x0
```
设置本机静态ip
ifconfig eth1 10.3.3.1
用本机mac地址虚拟远端IP（同网段）建立MAC映射
```
arp -s 10.3.3.2 3A:69:D0:D9:80:0A
```
或者
```
ip neigh add 10.3.3.2 lladdr 3A:69:D0:D9:80:0A dev eth1 nud permanent
```
抓包
```
tcpdump -i eth1 host 10.3.3.2 &
```
```
ping 10.3.3.2 -c 1
```
回环通的话能抓到2个包
