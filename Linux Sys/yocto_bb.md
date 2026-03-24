## bb文件调试
python形式，以python开头的可以使用如下调试
bb.plain, bb.note, bb.warn, bb.error, bb.fatal, bb.debug
```
python do_xxx() {
    ···
    bb.debug(2, "Got to point xyz")

    ···
}
```
bash形式
bbplain, bbnote, bbwarn, bberror, bbfatal, bbdebug
```
do_xxx() {
    ···
    bbplain "-----------debug-------------"
	bbdebug 3 "-----------debug-------------"
    ···
}
```
## 调试
bitbake xxx -c devshell
进入一个 shell，里面包含了构建时所需的所有环境变量和工具，可以在此环境中手动运行命令

生成pn-buildlist（任务要执行的软件包列表）
bitbake xxx -g

## 添加自定义任务
xxx.bbappend
添加任务do_prepare_patches，在do_patch和do_configure之间
```
addtask prepare_patches after do_patch before do_configure
do_prepare_patches() {
    xxx
}
```

