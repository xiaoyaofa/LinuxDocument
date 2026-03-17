## QT
### qt添加qtserial
fsl-image-qt5-validation-imx.bbappend
```
IMAGE_INSTALL中添加 qtserialport 和 qtserialbus
```

### qt添加sqlite
永久配置
meta-qt5/recipes-qt/qt5/qtbase_git.bb
添加
```
PACKAGECONFIG_SQLITE ?= "sql-sqlite"
```
PACKAGECONFIG中添加一行
```
${PACKAGECONFIG_SQLITE} \
```
当前工程配置
在build/conf/local.conf中添加
```
PACKAGECONFIG_append_pn-qtbase = " sql-sqlite"
```
### 更换qt镜像源
yocto指定把git://code.qt.io换成github
预镜像配置 (PREMIRRORS)
```
PREMIRRORS:prepend = " \
    git://code.qt.io/qt/*    git://github.com/qt/* \
    git://code.qt.io/qt/qtwebengine-chromium.git  git://github.com/qt/qtwebengine-chromium.git \
    git://code.qt.io/qt/qtquick3d-assimp.git  git://github.com/qt/qtquick3d-assimp.git \
    git://code.qt.io/qt/qtquick3d.git  git://github.com/qt/qtquick3d.git \
"
```

## 生成sdk没有qmake
IMAGE_INSTALL_append = " qtbase-dev qtbase-mkspecs qtbase-tools "
或者
镜像名字.bb文件里面添加
inherit populate_sdk_qt5

## colord
local.conf
DISTRO_FEATURES:append = " polkit dbus udev"

## 判断相关
举例
```
XXX = "${@bb.utils.contains(
    'COMBINED_FEATURES',  # 列表A：Yocto 组合特性列表（DISTRO_FEATURES + MACHINE_FEATURES）
    'opengles',           # 目标项：判断是否启用「opengles」特性
    'mali-library',       # 满足时（有opengles）：优先用 Mali 闭源驱动
    'mesa',               # 不满足时（无opengles）：优先用 Mesa 开源驱动
    d                     # Yocto 上下文参数（固定）
)}"
```