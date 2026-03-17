## layer
列出所有layer
```
bitbake-layers show-layers
```
### 添加layer
先从git上下载meta-xxx的代码(建议建一个layers文件夹，放下载的layer)
```
cd build
bitbake-layers add-layer <meta-xxx的相对路径>
```
查看是否添加成功
```
bitbake-layers show-layers
```
或者在build/conf/bblayers.conf中查看BBLAYERS
## 列出某个层内的所有配方
bitbake-layers show-recipes meta-xxx

列出配方在哪个meta和优先级
bitbake-layers show-recipes xxx

## BuildHistory
conf/local.conf
添加如下开启
```
INHERIT += "buildhistory"
BUILDHISTORY_COMMIT = "1"
```
收集image
```
BUILDHISTORY_COMMIT = "0"
BUILDHISTORY_FEATURES = "image"
```
### 查看软件包大小



### 删除layer
bitbake-layers remove-layer
## 列出配方
```
bitbake <包名> -s
```
## 列出可以执行的任务
```
bitbake <包名> -c listtasks
```

## 工具链
生成标准sdk
```
bitbake <镜像名字> -c populate_sdk
```
生成拓展sdk
```
bitbake <镜像名字> -c populate_sdk_ext
```
添加单个包
```
TOOLCHAIN_HOST_TASK:append += "pack"
```
目标机
```
TOOLCHAIN_TARGET_TASK:append += "pack"
```

## 离线编译
```
BB_NO_NETWORK = "1"
```

## 缓存
一般用于某个包编译报错，需要清除缓存重新编译
三种清除，清除能力由低到高
```
bitbake <包名> -c clean
bitbake <包名> -c cleansstate
bitbake <包名> -c cleanall
```
### build/tmp
构建时生成的缓存文件

## 查看yocto版本
poky/meta-poky/conf/distro/poky.conf
DISTRO_VERSION和DISTRO_CODENAME

## 只执行下载
bitbake <包名> --runall=fetch

## 修改kernel用自己github仓库
在对应的meta文件夹中找到linux-xxx-xxx.bb
修改
```
SRCREV = "对应commit值"
SRCBRANCH = "分支名字"
SRC_URI = "git://github.com/你的仓库地址;protocol=https;branch=分支名字  \
"
```
SRC_URI也可以指定成本地
本地不带git
SRC_URI = "file://目录;protocol=file;"
本地带git
SRC_URI = "git://目录;protocol=file;"

通过使用 gitsm://，Yocto 会自动处理子模块的克隆，无需额外手动操作。这对于项目中大量依赖子模块的情况尤为重要
`用git://替换gitsm://前缀`

## 指定任务数量
vim conf/local.conf
```
BB_NUMBER_THREADS = "4"     #多少任务
PARALLEL_MAKE = "-j 8"      #任务中执行线程数
```

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

    ···
}
```
## 调试
bitbake xxx -c devshell
进入一个 shell，里面包含了构建时所需的所有环境变量和工具，可以在此环境中手动运行命令

生成pn-buildlist（任务要执行的软件包列表）
bitbake xxx -g

## 添加模块
4种方法
MACHINE_ESSENTIAL_EXTRA_RDEPENDS
MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS
MACHINE_EXTRA_RDEPENDS
MACHINE_EXTRA_RRECOMMENDS
找到对应地方，在结尾加上kernel-module-xxx
模块的.bb文件中 RPROVIDES 后面是包名
## rootfs中不安装模块
IMAGE_INSTALL_remove += "kernel-module-xxx"

## 创建自己的meta
bitbake-layers create-layer --priority 7 ../layers/meta-st/meta-my-custo-layer

## 添加密码
在开发板上生成密文
echo "密码" | openssl passwd -6 -stdin
在image.bb中添加
```
inherit extrausers
EXTRA_USERS_PARAMS = "\
        usermod -p '密文' root; \
"
```
如果带有$符号需要加\转义


## 顺序
fetch -> unpack -> patch -> configure -> compile 
-> install -> package -> rootfs -> image

## 临时添加/移除包
conf/local.conf
```
PACKAGE_EXCLUDE = " xxx"
```
```optee-stm32mp-addons
PACKAGECONFIG_append_xxx = " xxx"
```
注意有空格
```
IMAGE_INSTALL_append = " xxx"
```
yocto 2.4
```
PACKAGECONFIG_xxx:remove = " xxx"
```
镜像中排查包
```
IMAGE_INSTALL_remove += " xxx"
```

## 禁用网络
BB_NO_NETWORK = "1"

## 禁用QA检查
禁用file-rdeps类型QA检查
```
INSANE_SKIP_${PN} += "file-rdeps"
```
## 改用systemd服务
```
DISTRO_FEATURES_append = " systemd"
VIRTUAL-RUNTIME_init_manager = "systemd"
```

## 查看DISTRO_FEATURES
bitbake -e | grep "^DISTRO_FEATURES="

## 多个bb版本，指定yocto编译一个
conf/distro/include/default-versions.inc
或者
conf/local.conf
```
PREFERRED_VERSION_xxx="1.2.%"
```

## github镜像
vi conf/local.conf
```
PREMIRRORS:prepend = " \
    git://.*/.*    git://bgithub.xyz/ \
    https://.*/.*  https://bgithub.xyz/ \
    http://github.com/   http://bgithub.xyz/ \
"
```

## 清空依赖链缓存
```
bitbake xxx -g
cat pn-buildlist | xargs bitbake -c cleansstate
```

## 调试内核
编译内核
bitbake virtual/kernel -c clean
bitbake virtual/kernel
启动菜单配置界面
bitbake virtual/kernel -c menuconfig
将临时配置合并到默认配置
bitbake virtual/kernel -c diffconfig
然后把补丁文件放到内核配方

## uboot
bitbake virtual/bootloader -c clean


## 开启接受所有的commercial license软件包
LICENSE_FLAGS_WHITELIST="commercial"

# 构建
## 路径
${D}
目标文件的安装目录
```
${WORKDIR}/image
```
${B}
构建目录
```
${WORKDIR}/${BPN}-${PV}/build
```
${S}
解压后的源代码目录
```
${WORKDIR}/${BPN}-${PV}/sources
```
${WORKDIR}
当前配方的工作目录，包含构建过程中生成的临时文件
```
${TMPDIR}/work/${MULTIMACH_TARGET_SYS}/${PN}/${PV}-${PR}
```
${TOPDIR}
build目录

${ECIPE_SYSROOT}
指向配方依赖的库和头文件的系统根目录，用于交叉编译时访问目标架构的依赖项
```
${WORKDIR}/recipe-sysroot
```
${bindir}
```
/usr/bin
```
${sbindir}
```
/usr/sbin
```
${includedir}

${libdir}
```
/usr/lib
```
${sysconfdir}
```
/etc
```
${systemd_system_unitdir}
```
/lib/systemd/system
```

## 代理名字
当前配方的包名
```
${PN}
```

### 拆分lib库
确保安装所有库版本
```
FILES:${PN} += " \
    ${libdir}/libteec.so.* \
    ${libdir}/libckteec.so.* \
"
```
明确声明提供共享库
```
PROVIDES += "libckteec"
```
添加共享库的包名
```
PACKAGES =+ "libckteec"
```
为每个库创建单独的包
```
FILES:libckteec = "${libdir}/libckteec.so.*"
```
设置运行时依赖关系
```
RDEPENDS:${PN} += "libckteec"
```

## 跳过特定检查
INSANE_SKIP_${PN} += "dev-so libdir staticdev file-rdeps"
```
dev-so：开发符号链接问题
libdir：库文件路径错误
already-stripped：文件重复剥离
arch：架构不匹配
```

# 官方文档
https://docs.yoctoproject.org/