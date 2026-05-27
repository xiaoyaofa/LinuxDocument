## nc
```
nc -v 192.168.1.40 8222
```

## socat
tcp伪终端
```
socat FILE:$(tty),raw,echo=0,escape=0x0f TCP:192.168.1.40:8222
```
Ctrl+O 退出连接