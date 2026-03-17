## Permission denied, please try again.
```
vi /etc/ssh/sshd_config
```
```
PasswordAuthentication yes
PermitRootLogin yes
```
```
service sshd restart
或者
/etc/init.d/sshd restart
```
## 删除密钥
Linux
```
ssh-keygen -f "~/.ssh/known_hosts" -R "192.168.1.11"
```
Win
```
ssh-keygen -f C:\\Users\\myir_/.ssh/known_hosts -R "192.168.1.17"
```

## 指定密钥类型
ssh root@192.168.1.17 -o HostKeyAlgorithms=+ssh-rsa