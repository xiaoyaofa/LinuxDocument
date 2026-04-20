## bear工具
安装bear工具核心目的是为了编译内核代码把参与的编译文件和关联头文件生成到json文件里，供后续的clangd解析，避免未参与编译的文件被索引。
### 在线安装
```
apt install bear
```
### 使用bear编译生成json文件
进入linux工程代码下，在编译Image阶段，make命令前加入bear，如：(make clean从头编译)
```
bear --libear /usr/lib/x86_64-linux-gnu/bear/libear.so make -j
```
–libear /usr/lib/libear.so为指定libear库路径
bear 版本大于3.0，用如下
```
bear --library /usr/lib/x86_64-linux-gnu/bear/libexec.so -- make -j16
```


如果编译顺利并完成，将会生成**compile_commands.json**，就是我们最后想要的文件

## clangd工具
### 下载&安装
1.打开vscode，并remote ssh到ubunut下。
2.vscode remote里安装clangd拓展插件。
3.ubunutu中安装clangd工具
### 配置clangd工具
![alt text](/picture/clangd_config.png)

1.添加配置参数，注意一行一行加入。
```
--compile-commands-dir=${workspaceFolder}
--background-index
--completion-style=detailed
--header-insertion=never
--log=info
```
![alt text](/picture/clangd_add.png)

2.禁用C/C++ extension有代码跳转功能的相关插件，否则与clangd可能有冲突。
3.workspace路径下手动添加.clangd文件。否则会后面生成index过程可能会报错：`Couldn’t build compiler instance...`
### clangd生成符号表索引数据库
配置完clangd后，重新打开vscode代码，可以看到状态栏clangd开始工作，indexing所有文件。或者可以输入`Ctrl` + `Shift` + `p`，然后执行`>clangd: Restart language server` 手动重启clangd服务来触发索引。
等待完成后，生成的索引数据库位于`.cache/clangd/index/`下
完成。到此已经可以正常进行代码跳转、变量补全开发等。
### (补充)
在.clangd中添加如下可以去除一些错误提示
```
CompileFlags: 
    Add:    [-Wno-unknown-warning-option, -Wno-int-to-pointer-cast]
    Remove: [-m*, -f*, -W*]
```

vscode里设置里关掉Error Squiggles去除C/C++的错误提示

### 参考
[点击前往!](https://blog.csdn.net/ludaoyi88/article/details/135051470?spm=1001.2014.3001.5506)

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDB8tQKEb547C/naf3aJpfZBBrCsU7khKwKl1VHW6tcHN4BR3BbolVhBcOWwGkRTqN5jMlP1BdD7ORvu174T3BnBsaO80lGHql3z29+lOZ/NDceoxymfkuE9+eR9i/ScdaLmhO8jTs3AdsRpj09KNMllkmzIWsDF1Qi3/q869uPrnRVMSUynZN4Xn+ckPOzcFyhYlhyu8/K4r73mfo2Ep2I61+vZ7FgfD3FwjTaZ1N3rFYkoR4/wlQpTIIkqO3WWd8xukGf2zKNtJAqsYEUZVdpVUpWLDZRDAFxaYzSsr4dZoejZwUfHAe67MteHD/Ff0Pl8tYfy/Se4j17SnZOVHTxss2aaSWClwM4Xk+533UvksxA8n/0saIGZbF621MERakikH/h/1qbkefV4TgAHpV1jcntTkkb9FYzhVWkLjEiViKP7yEYzggPx45B+fPWiJu8PovSdtsTyMaETTixYg3SusQaR4c9yYahYuQhF+EKf3P15D888zvrvu1x2gv9zl0= 1240980018@qq.com
