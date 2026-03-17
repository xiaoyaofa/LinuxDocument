## 基础命令
### 拉取镜像
```
docker pull ubuntu:22.04
```
### 创建容器
--name指定创建的容器名字
-i 控制台交互
-t 支持终端登录
-d 后台运行
```
docker run --name ubuntu22.04 -itd ubuntu:22.04 /bin/bash
```
共享文件夹
```
docker start -itd --name=ubuntu22.04 -v /opt/docker-share:/docker-share ubuntu22.04
```
### 查询
查看镜像
```
docker images
```
查看运行的容器
```
docker ps -a
```
### 进入容器
```
docker exec -it ubuntu22.04 bash
```
指定用户
```
docker exec -it --user xie ubuntu22.04 /bin/bash
```
### 启动和停止容器
```
docker start ubuntu22.04
```
```
docker stop ubuntu22.04
```
再次进入已经停止的容器
```
docker start -ai ubuntu22.04
```
### 删除镜像
删除镜像前必须先删除依赖它的容器
```
docker stop hello_world
docker rm hello_world
```
删除镜像
```
docker rmi hello_world
```
### 拷贝
将文件从镜像中拷贝出来
```
docker cp <镜像名字>:<目录> <目标目录>
```
将文件拷贝到镜像
```
docker cp <文件> <镜像名字>:<目录> 
```


## 持久化
### 创建镜像
基于现有容器创建镜像
```
docker commit -m "add share dir base" ubuntu22.04 my_new_image:v1
```
### 数据卷




## Dockerfile
Dockerfile 是用于构建 Docker 镜像的文本文件，包含一系列指令，用于自动化配置容器运行环境、安装软件和设置应用启动方式。

