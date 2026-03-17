### 开发板:IMX93(64位)
### 编译器:aarch64-linux-gnu 5.3.1

#### 下载交叉编译器并解压

#### 下载tslib1.4
解压后进入源码目录，执行
```
./autogen.sh
```
导入交叉编译器的环境变量
```
export PATH=/home/lubancat/SDK/gcc-linaro-5.3.1-2016.05-x86_64_aarch64-linux-gnu/bin:$PATH
```
--host为自己交叉编译器前缀，--prefix为安装目录
```
./configure CC=aarch64-linux-gnu-gcc CXX=aarch64-linux-gnu-g++ --host=aarch64-linux-gnu --prefix=/home/lubancat/qt-everywhere/tslib-install ac_cv_func_malloc_0_nonnull=yes

make
make install
```

#### 下载qt-everywhere-opensource-src-4.7.3
在qt-everywhere-opensource-src-4.7.3目录下创建一个.sh文件
文件内容
导入交叉编译器的环境变量
```
export PATH=/home/lubancat/SDK/gcc-linaro-5.3.1-2016.05-x86_64_aarch64-linux-gnu/bin:$PATH
```
```
#!/bin/sh
./configure -opensource \
--prefix=/home/lubancat/qt-everywhere/qt-4.7.3-arm \
-xplatform qws/aarch64-linux-gnu-g++ \
-embedded armv8 -release -webkit -no-cups -qt-zlib -qt-libjpeg -qt-libmng -qt-libpng -depths all -qt-gfx-linuxfb \
-qt-gfx-transformed -no-gfx-qvfb -qt-gfx-vnc -qt-gfx-multiscreen -qt-kbd-tty -no-openssl -no-phonon -no-phonon-backend -no-nas-sound \
-no-exceptions -svg -no-qt3support -no-multimedia -no-xmlpatterns -no-pch -confirm-license \
-no-mouse-qvfb -qt-mouse-linuxtp -qt-mouse-tslib \
-I/home/lubancat/qt-everywhere/tslib-install/include \
-L/home/lubancat/qt-everywhere/tslib-install/lib \
-DQT_QLOCALE_USES_FCVT -DQT_NO_QWS_CURSOR -no-pch
```
开发板使用armv8架构，-embedded一定是armv8，使用其他会编译报错
```
cp mkspecs/qws/linux-arm-gnueabi-g++ mkspecs/qws/aarch64-linux-gnu-g++
```
并且修改mkspecs/qws/aarch64-linux-gnu-g++里面的qmake.conf，改为
```
#
# qmake configuration for building with aarch64-poky-linux-g++
#

include(../../common/g++.conf)
include(../../common/linux.conf)
include(../../common/qws.conf)

QMAKE_INCDIR = /home/lubancat/qt-everywhere/tslib-install/include 
QMAKE_LIBDIR = /home/lubancat/qt-everywhere/tslib-install/lib

# modifications to g++.conf
QMAKE_CC                = aarch64-linux-gnu-gcc -lts
QMAKE_CXX               = aarch64-linux-gnu-g++ -lts
QMAKE_LINK              = aarch64-linux-gnu-g++ -lts
QMAKE_LINK_SHLIB        = aarch64-linux-gnu-g++ -lts

# modifications to linux.conf
QMAKE_AR                = aarch64-linux-gnu-ar cqs
QMAKE_OBJCOPY           = aarch64-linux-gnu-objcopy
QMAKE_STRIP             = aarch64-linux-gnu-strip

load(qt_config)
```
先执行.sh脚本文件

然后导入交叉编译器环境
```
export PATH=/home/lubancat/SDK/gcc-linaro-5.3.1-2016.05-x86_64_aarch64-linux-gnu/bin:$PATH
```
```
make -j8
make install
```
#### 报错解决
##### 错误一
```
dialogs/qpagesetupdialog_unix.cpp:276:12: 错误： ‘class Ui::QPageSetupWidget’ has no member named ‘topMargin’
     widget.topMargin->setSuffix(suffix);
            ^
dialogs/qpagesetupdialog_unix.cpp:277:12: 错误： ‘class Ui::QPageSetupWidget’ has no member named ‘bottomMargin’
     widget.bottomMargin->setSuffix(suffix);
            ^
dialogs/qpagesetupdialog_unix.cpp:278:12: 错误： ‘class Ui::QPageSetupWidget’ has no member named ‘leftMargin’
     widget.leftMargin->setSuffix(suffix);
······

```
gcc版本过高
更换gcc版本为gcc7后，重新从./configure开始

参考
https://blog.csdn.net/u013028556/article/details/123404294?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522171835370816800222883613%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=171835370816800222883613&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-1-123404294-null-null.142^v100^control&utm_term=dialogs%2Fqpagesetupwidget.ui%3A%20Warning%3A%20Buddy%20assignment%3A%20paperSize%20is%20not%20a%20valid%20widget.&spm=1018.2226.3001.4187

##### 错误二
```
runtime/JSValue.h: In constructor 'JSC::JSValue::JSValue(JSC::JSCell*)':
runtime/JSValue.h:494:57: error: cast from 'JSC::JSCell*' to 'int32_t {aka int}' loses precision [-fpermissive]
         u.asBits.payload = reinterpret_cast<int32_t>(ptr);
                                                         ^
runtime/JSValue.h: In constructor 'JSC::JSValue::JSValue(const JSC::JSCell*)':
runtime/JSValue.h:506:78: error: cast from 'JSC::JSCell*' to 'int32_t {aka int}' loses precision [-fpermissive]
         u.asBits.payload = reinterpret_cast<int32_t>(const_cast<JSCell*>(ptr));
                                                                              ^
make[1]: *** [.obj/release-static-emb-armv8/JSBase.o] Error 1
make[1]: Leaving directory `/opt/qt-everywhere-opensource-src-4.7.3/src/3rdparty/webkit/JavaScriptCore'
make: *** [sub-javascriptcore-make_default-ordered] Error 2
```
```
找到报错对应的JSValue.h文件
vim src/3rdparty/javascriptcore/JavaScriptCore/runtime/JSValue.h
```
将下面代码中的int32_t改成int64_t
```
487 
488     inline JSValue::JSValue(JSCell* ptr)
489     {
490         if (ptr)
491             u.asBits.tag = CellTag;
492         else
493             u.asBits.tag = EmptyValueTag;
494         u.asBits.payload = reinterpret_cast<int32_t>(ptr);
495 #if ENABLE(JSC_ZOMBIES)
496         ASSERT(!isZombie());
497 #endif
498     }
499 
500     inline JSValue::JSValue(const JSCell* ptr)
501     {
502         if (ptr)
503             u.asBits.tag = CellTag;
504         else
505             u.asBits.tag = EmptyValueTag;
506         u.asBits.payload = reinterpret_cast<int32_t>(const_cast<JSCell*>(ptr));
507 #if ENABLE(JSC_ZOMBIES)
508         ASSERT(!isZombie());
509 #endif
510     }
```
重新编译

参考
https://blog.csdn.net/prochsh/article/details/121034987?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522171835153616777224482587%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=171835153616777224482587&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-121034987-null-null.142^v100^control&utm_term=%E4%BA%A4%E5%8F%89%E7%BC%96%E8%AF%91qt4.7.3&spm=1018.2226.3001.4187

##### 错误三
```
错误： selected processor does not support `swp x19,x1,[x2]'
make[1]: *** [Makefile:17816：.obj/release-shared-emb-arm/qobject.o] 错误 1
```
说明./configure时-embedded的mpu架构跟你开发板对不上

##### 错误四
```
libQtCore.so: undefined reference to `QInotifyFileSystemWatcherEngine::create()'
```

```
vi ./src/corelib/io/io.pri
```

举例:
my toolchains's prefix is aarch64-linux
```
68        linux-*|aarch64-linux*:{            //该行改为自己对应工具链前缀
69             SOURCES += \
70                     io/qfilesystemwatcher_inotify.cpp \
71                     io/qfilesystemwatcher_dnotify.cpp
72
73             HEADERS += \
74                     io/qfilesystemwatcher_inotify_p.h \
75                     io/qfilesystemwatcher_dnotify_p.h
76         }
```

#### 开发板环境变量
```
export TS_ROOT=~/tslib-install
export LD_LIBRARY_PATH=$TS_ROOT/lib:$LD_LIBRARY_PATH
export PATH=$TS_ROOT/bin:$PATH
export TSLIB_CONSOLEDEVICE=none
export TSLIB_FBDEVICE=/dev/fb0
export TSLIB_TSDEVICE=/dev/input/touchscreen0
export TSLIB_CALIBFILE=$TS_ROOT/etc/pointercal
export TSLIB_CONFFILE=$TS_ROOT/etc/ts.conf
export TSLIB_PLUGINDIR=$TS_ROOT/lib/ts

export QT_ROOT=~/qt-4.7.3-arm
export LD_LIBRARY_PATH=$QT_ROOT/lib/:$LD_LIBRARY_PATH
export QWS_MOUSE_PROTO=tslib:/dev/input/touchscreen0
export QT_QWS_DISPLAY=linuxfb:/dev/fb0
export QT_QWS_FONTDIR=$QT_ROOT/lib/fonts/
export PLUGIN_PATH=$QT_ROOT/plugins
```

#### 测试
运行examples下的例子测试

#### qt creator
如果qt creator版本太高，创建项目后记得在项目配置中加入，
更换成c++11编译
```
QMAKE_CXXFLAGS += -std=c++11
```