在新版本构建的文件系统中/lib是链接文件
/lib -> /usr/lib
有时候不小心删除了根目录下面的/lib，怎么恢复
这个时候不能重启板子
通过ld-linux-aarch64.so.1就能运行命令
```
/usr/lib/ld-linux-aarch64.so.1 /usr/bin/ls
```
重新创建链接文件
```
/usr/lib/ld-linux-aarch64.so.1 /usr/bin/ln -s /usr/lib /lib
```