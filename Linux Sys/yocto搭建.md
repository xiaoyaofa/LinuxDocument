编写时间2024.6
### 环境
Ubuntu20.04

### 安装工具包
```
sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
     pylint3 xterm -y
#或者Ubuntu最新版本安装下面的
sudo apt install gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm python3-subunit mesa-common-dev zstd liblz4-tool -y
```
### 下载yocto源码
```
git clone https://github.com/yoctoproject/poky.git
cd poky
git fetch --tags
```
查看所有远程分支
```
git branch -r
```
建议签出一个长期支持的稳定版本，Honister(yocto3.4)以后语法有大变动，不建议入门使用，这里以比Hardnott(yocto3.3)为例。
```
git checkout -t origin/hardknott -b my-hardknott
```
### 加载编译环境
```
source oe-init-build-env
```
首次使能会创建build目录，后面编译和输出的所有对象都在这个build目录下。build目录下改动都是临时的，不建议(不建议≠不能改)在build目录下修改代码。
### 编译安装
```
bitbake core-image-sato
```
因为要下载配方中的软件包并进行配置、编译、安装，第一次时间是很长的(挂一晚上说不定就好了)

### 使用qemu仿真
```
runqemu qemux86-64
```
完整命令如下
```
runqemu <machine> <zimage> <filesystems>
```