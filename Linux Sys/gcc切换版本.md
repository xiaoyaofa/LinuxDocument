## 安装gcc7并切换版本
```
sudo apt-get install gcc-7 g++-7
```
使用update-alternatives进行版本切换，输入以下命令
```
# update-alternatives: --install <链接> <名称> <路径> <优先级>
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 100
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 50

sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 100
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 50

```
查看gcc的默认版本，可以看到当前默认gcc版本为7，即切换成功。
```
sudo update-alternatives --config gcc
```
查看当前gcc命令的软链接
```
ls -liat /usr/bin/gcc 
528697 lrwxrwxrwx 1 root root 21 3月  10 13:45 /usr/bin/gcc -> /etc/alternatives/gcc
ls -liat /usr/bin/g++
528698 lrwxrwxrwx 1 root root 21 3月  10 13:48 /usr/bin/g++ -> /etc/alternatives/g++
```