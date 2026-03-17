vi /etc/resolv.conf
```
nameserver 202.102.192.68
nameserver 202.102.192.69
```
echo "nameserver 202.102.192.68" >> /etc/resolv.conf
echo "nameserver 202.102.192.69" >> /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf