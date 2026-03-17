## Docker-CE
## 安装https
apt install apt-transport-https ca-certificates curl software-properties-common

## 添加下载源
vi /etc/apt/sources.list.d/docker.list
```
deb [arch=arm64] https://mirrors.cloud.tencent.com/docker-ce/linux/ubuntu/ focal stable
```
## 添加官方密钥
curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/ubuntu/gpg | apt-key add -
```
chown -R man: /var/cache/man/
chmod -R 755 /var/cache/man/
```
安装
查看 Docker CE 可用版本
apt-cache madison docker-ce
查看 containerd.io 可用版本
apt-cache madison containerd.io
查看 Docker Compose Plugin 可用版本
apt-cache madison docker-compose-plugin
```
apt update
apt install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-compose-plugin
```
如果过程中遇到依赖问题，尤其是与 containerd 或 containerd.io 相关的冲突
```
apt remove containerd.io
```

## 启动服务
systemctl start docker

## 报错
iptables/1.8.7 Failed to initialize nft
```
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
update-alternatives --set arptables /usr/sbin/arptables-legacy
```
### 添加docker镜像源
vi /etc/docker/daemon.json
```
{
    "registry-mirrors": [
        "https://docker.m.daocloud.io", 
        "https://docker.imgdb.de", 
        "https://docker-0.unsee.tech", 
        "https://docker.hlmirror.com", 
        "https://cjie.eu.org", 
        "https://registry.docker-cn.com", 
        "https://docker.mirrors.ustc.edu.cn", 
        "https://hub-mirror.c.163.com", 
        "https://mirror.baidubce.com", 
        "https://ccr.ccs.tencentyun.com"
    ]
}
```
systemctl daemon-reload
systemctl restart docker

## 运行
docker run hello-world
### 报错

bpf_prog_query(BPF_CGROUP_DEVICE) failed: function not implemented: unknown

检查内核缺少配置
```
wget https://github.com/moby/moby/raw/master/contrib/check-config.sh
```
根据脚本中缺少的内容去配置内核
```

```
