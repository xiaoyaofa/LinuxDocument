## 查看密钥环
```
keyctl show
```
列出系统密钥环中的密钥
```
keyctl list @s
```

## 添加密钥到密码环
```
keyctl add <type> <desc> <data> <keyring>
```
列如，logon是类型，logkey:是名称 @s是系统密钥环
```
cat mykey | keyctl padd logon logkey: @s
```

## 删除密钥环中的密钥
```
keyctl unlink <ID> @s
```
举例
```
keyctl search @s logon logkey\:
78108069
keyctl unlink 78108069 @s
```