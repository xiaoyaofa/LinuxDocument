## Ubuntu部署谷歌浏览器
apt install xterm 

apt update
apt install fuse squashfuse libsquashfuse0
apt install squashfs-tools snapd snap
apt install chromium-bsu
apt install xz-utils

apt install chromium-browser
snap install chromium

报错
```
[  113.110611] Filesystem uses "xz" compression. This is not supported
error: system does not fully support snapd: cannot mount squashfs image using
       "squashfs": mount: /tmp/syscheck-mountpoint-694139781: wrong fs type,
       bad option, bad superblock on /dev/loop0, missing codepage or helper
       program, or other error.
```
内核配置开启
```
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_FILE_DIRECT=y
CONFIG_SQUASHFS_DECOMP_SINGLE=y
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZ4=y
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_ZSTD=y
CONFIG_SQUASHFS_XATTR=y
<!-- CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3 -->
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
<!-- CONFIG_GREYBUS=y
CONFIG_STAGING=y
CONFIG_GREYBUS_LOOPBACK=y
CONFIG_SQUASHFS_FILE_DIRECT=y
CONFIG_SECURITY=y
CONFIG_SECURITY_APPARMOR=y
CONFIG_BPF_SYSCALL=y -->
```
```
[  160.444304] squashfs: SQUASHFS error: Xattrs in filesystem, these will be ignored
[  160.452151] unable to read xattr id index table
```
编译内核
```
*
* Restart config...
*
*
* ARMv8.3 architectural features
*
Enable support for pointer authentication (ARM64_PTR_AUTH) [Y/n/?] (NEW) Y
*
* ARMv8.4 architectural features
*
Enable support for the Activity Monitors Unit CPU extension (ARM64_AMU_EXTN) [Y/n/?] y
Enable support for tlbi range feature (ARM64_TLB_RANGE) [Y/n/?] (NEW) Y
```
apt install chromium

### 用snap下载卡住
更换下载源
apt install software-properties-common
add-apt-repository ppa:xtradeb/apps
apt update
apt install chromium

谷歌浏览器没找到wayland启动
改用火狐
apt install firefox

XDG_DATA_DIRS="/usr/local/share:/usr/share:/var/lib/snapd/desktop"
XDG_RUNTIME_DIR="/run/user/0"
XDG_SESSION_CLASS="user"
XDG_SESSION_ID="1"
XDG_SESSION_TYPE="tty"

### wayland启动，GPU报错
chromium --enable-features=UseOzonePlatform --ozone-platform=wayland --no-sandbox


## 采用qt浏览器
yocto
添加qtwebengine
meta-myir-yg2lx/conf/layer.conf
注释
```
BBMASK_append = " qtwebengine "
```

编译报错
```
ERROR: Nothing PROVIDES 'qtwebengine'
qtwebengine was skipped: Requires meta-python2 to be present.
```
layer下面添加meta-python2
git clone git://git.openembedded.org/meta-python2
```
bitbake-layers add-layer ../layers/meta-openembedded/meta-python2
```
添加python2层报错
```
ERROR: Layer meta-python2 is not compatible with the core layer which only supports these series: dunfell (layer is compatible with kirkstone)
ERROR: Parse failure with the specified layer added, aborting.
```
切换meta-python2分支到yocto对应版本
git -C meta-python2 checkout dunfell

报错
```
| stderr:
| 
| Package xkbcommon was not found in the pkg-config search path.
| Perhaps you should add the directory containing `xkbcommon.pc'
| to the PKG_CONFIG_PATH environment variable
| No package 'xkbcommon' found

```
sudo apt install libxkbcommon-x11-dev
sudo apt install apt-file
sudo apt-file update
查找xkbcommon.pc是否安装成功
apt-file search xkbcommon.pc
```
DEPENDS += " \
    libxkbcommon \
"
```
再编译报错
```
| ERROR:root:code for hash sha1 was not found.
```
发现python-pyopenssl没编译进去

<!-- 更换openssl版本为1.0.2u
```
layers/meta-myir-yg2lx/recipes-common/recipes-debian/openssl
更换.bb和openssl文件夹
``` -->


bitbake python-pluggy报错
```
bitbake python-pluggy -c devshell
#下载pip
python get-pip.py
python -m pip install testresources
```
bitbake python-hypothesis报错同上
bitbake python-pytest报错同上

pip install testresources 
pip install setuptools

<!-- qtbase do_configure报错
```
| test config.qtbase_gui.libraries.libmd4c FAILED
| Done running configuration tests.
``` 
openssl版本太低，要>=1.1.0
-->
### 生成镜像
layers/meta-myir-yg2lx/recipes-images/images/myir-image-full.bb
```
IMAGE_INSTALL += " \
···
    qtwebkit \
    qtwebview \
    qtwebengine \
    qtwebglplugin \
···
```
### 生成SDK
layers/meta-qt5/recipes-qt/packagegroups/packagegroup-myir_qt5-toolchain-target.bb
```
RDEPENDS_${PN} += " \
···
    qtwebkit \
    qtwebkit-dev \
    qtwebkit-mkspecs \
    qtwebview \
    qtwebview-dev \
    qtwebview-mkspecs \
    qtwebengine \
    qtwebengine-dev \
    qtwebengine-mkspecs \
    qtwebglplugin \
    qtwebglplugin-dev \
    qtwebglplugin-mkspecs \
···
```