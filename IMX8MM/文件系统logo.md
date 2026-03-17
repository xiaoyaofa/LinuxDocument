## 关闭logo
```
systemctl disable psplash-start
```
## 修改logo
```
git clone git://git.yoctoproject.org/psplash
cd psplash
```
准备一个.png格式的图片
./make-image-header.sh xxx.png POKY
生成
xxx.h
将xxx.h复制到yocto的
sources/poky/meta/recipes-core/psplash/files
修改
sources/poky/meta/recipes-core/psplash/psplash_git.bb
```
SPLASH_IMAGES = "file://xxx.h;outsuffix=default"
```
编译yocto，生成psplash-default和psplash-write拷贝进开发板/usr/bin