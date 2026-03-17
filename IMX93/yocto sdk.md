sources/meta-qt6/recipes-qt/packagegroups/packagegroup-qt6-addons.bb
去除qt3d相关
```
#edit by xie
#remove ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'qt3d', '', d)}
#remove ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'qtdatavis3d', '', d)}
```