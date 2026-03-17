qt基础配置
```
#!/bin/bash
./configure \
-extprefix /home/lubancat/qt-everywhere/qt-remi-arm \
-confirm-license \
-opensource \
-release \
-make libs \
-xplatform linux-aarch64-gnu-g++ \
-pch \
-qt-libjpeg \
-qt-libpng \
-qt-zlib \
-no-opengl \
-no-sse2 \
-no-openssl \
-no-cups \
-no-glib \
-no-dbus \
-no-xcb \
-no-separate-debug-info \
-no-ssl \
-nomake tests \
-nomake examples \
-nomake tools \
-no-sql-sqlite \
-no-iconv \
-skip qt3d \
-skip qtactiveqt \
-skip qtcanvas3d \
-skip qtcharts \
-skip qtconnectivity \
-skip qtdatavis3d \
-skip qtdeclarative \
-skip qtgamepad \
-skip qtandroidextras \
-skip qtdoc \
-skip qtwebchannel \
-skip qtwebengine \
-skip qtwebglplugin \
-skip qtwebview \
-skip qtvirtualkeyboard \
-recheck
```
以上配置不会报错