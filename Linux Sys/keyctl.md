## 查看密钥环
```
keyctl show
```
列出系统密钥环中的密钥
```
keyctl list @s
```
读取`user`类型密钥
```
keyctl pipe xxx | hexdump -C
```

## 添加密钥到密码环
```
keyctl add <type> <desc> <data> <keyring>
```
**常用密钥类型**
- **`user`**：最通用的用户密钥，用户空间可读可写
- **`logon`**：登录凭证密钥，**用户空间不可读、仅内核可访问**
- **`trusted/encrypted`**：受信任密钥，依赖 TPM/TEE 硬件，需要内核开启对应配置
**常用 keyring 快捷标识**
- `@s`：当前会话的 session keyring（进程退出 / 重启后失效）
- `@u`：当前用户的 user keyring（持久化，重启后仍保留）
- `@t`：当前线程的 thread keyring
- `@p`：当前进程的 process keyring

列如，logon是类型，logkey:是名称 @s是系统密钥环
```
cat mykey | keyctl padd logon logkey: @s
```
从标准输入读取密钥
```
keyctl padd [可选参数] <密钥类型> <密钥描述符> <目标keyring>
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