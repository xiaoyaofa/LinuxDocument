使用LMX9X的qt6.5.0版本

layers/meta-myir-remi/recipes-images/images/myir-image-full.bb

IMAGE_INSTALL
```
#remove
qt-demo \
qtquickcontrols \
qtquickcontrols2 \
qtquickcontrols2-dev \
qtgraphicaleffects \
qtmultimedia \
qtvirtualkeyboard \

#change
```
CORE_IMAGE_EXTRA_INSTALL
```
#edit by xie
#add 
packagegroup-qt6-toolchain-target \
#remove
packagegroup-qt5-toolchain-target \
```
conf/local.conf

IMAGE_INSTALL_append
```
#remove
qtgamepad \
qtdeclarative \
```
layers/meta-myir-remi/recipes-demos/measy-hmi/qt-demo.bb
DEPENDS
```
#remove
qtquickcontrols \
qtquickcontrols2 \
```