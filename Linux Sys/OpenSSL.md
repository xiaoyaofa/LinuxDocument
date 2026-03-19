## 简介
OpenSSL 是一个强大的开源加密工具包，提供了各种加密算法、证书管理功能和 SSL/TLS 协议实现。它是 Linux 系统中处理加密任务的事实标准工具。

OpenSSL 主要功能包括：
- 创建和管理 SSL 证书
- 加密/解密文件
- 生成密钥对
- 测试 SSL 连接
- 计算哈希值
- 数字签名验证

## 常用子命令及示例
### 1. 生成 RSA 密钥对

生成 2048 位的 RSA 私钥：
```
openssl genrsa -out private.key 2048
```

从私钥提取公钥：
```
openssl rsa -in private.key -pubout -out public.key
```

参数说明：
- `-out`：指定输出文件
- `2048`：密钥长度（位）
- `-pubout`：输出公钥

### 2. 创建自签名证书

生成 CSR（证书签名请求）：
```
openssl req -new -key private.key -out cert.csr
```
生成自签名证书（有效期365天）：

```
openssl req -x509 -new -key private.key -days 365 -out cert.crt
```

参数说明：
- `-new`：创建新请求
- `-key`：指定私钥文件
- `-days`：证书有效期（天）
- `-x509`：输出 X.509 格式证书
### 3. 文件加密与解密

使用 AES-256-CBC 加密文件：
```
openssl enc -aes-256-cbc -salt -in plaintext.txt -out encrypted.enc
```

解密文件：
```
openssl enc -d -aes-256-cbc -in encrypted.enc -out decrypted.txt
```

参数说明：
- `-aes-256-cbc`：使用 AES-256-CBC 算法
- `-salt`：添加随机盐值增强安全性
- `-in`：输入文件
- `-out`：输出文件
- `-d`：解密模式

### 4. 计算文件哈希值

计算 SHA-256 哈希：
```
openssl dgst -sha256 filename.txt
```

计算 MD5 哈希：
```
openssl dgst -md5 filename.txt
```

### 5. 测试 SSL 连接

测试远程服务器的 SSL 证书：
```
openssl s_client -connect example.com:443 -showcerts
```

参数说明：
- `-connect`：指定主机和端口
- `-showcerts`：显示服务器证书链

## 生成FITImage加签用的密钥

```
openssl genpkey -algorithm RSA -out keys/dev.key -pkeyopt rsa_keygen_bits:2048 -pkeyopt rsa_keygen_pubexp:65537
```

| 参数                                 | 含义          |
| ---------------------------------- | ----------- |
| `genpkey`                          | 生成私钥        |
| `-algorithm RSA`                   | 指定加密算法      |
| `-out keys/dev.key`                | 输出路径        |
| `-pkeyopt rsa_keygen_bits:2048`    | 密钥长度 2048 位 |
| `-pkeyopt rsa_keygen_pubexp:65537` | 公钥指数 65537  |

```
openssl req -batch -new -x509 -key keys/dev.key -out keys/dev.crt
```

| 参数                  | 含义          | 作用                                  |
| ------------------- | ----------- | ----------------------------------- |
| `req`               | 证书请求 / 生成工具 | 用于生成 CSR 或 X.509 证书                 |
| `-batch`            | 批量模式        | **不弹出交互提问**（国家 / 组织 / 域名等自动留空），脚本专用 |
| `-new`              | 生成新证书       | 创建全新证书                              |
| `-x509`             | 生成自签名证书     | 直接生成可用证书，而非待签名的 CSR                 |
| `-key keys/dev.key` | 绑定私钥        | 用刚才生成的私钥对证书进行签名                     |
| `-out keys/dev.crt` | 输出证书        | 保存为 X.509 格式证书                      |

## 参考链接
[Linux openssl 命令 | 菜鸟教程](https://www.runoob.com/linux/linux-comm-openssl.html)