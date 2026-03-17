## 添加自定义任务
xxx.bbappend
```
do_prepare_patches() {
    xxx
}
# 添加任务do_prepare_patches，在do_patch和do_configure之间
addtask do_prepare_patches after do_patch before do_configure
```