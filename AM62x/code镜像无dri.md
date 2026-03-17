## 无fb/dri节点问题
myir-image-core.bb中的IMAGE_INSTALL添加
```
${@bb.utils.contains('DISTRO_FEATURES','opengl','packagegroup-myir-tisdk-graphics','',d)} \
${@bb.utils.contains('DISTRO_FEATURES','opengl','packagegroup-myir-tisdk-gtk','',d)} \
${@['','packagegroup-myir-tisdk-opencl'][oe.utils.all_distro_features(d, 'opencl', True, False) and bb.utils.contains('MACHINE_FEATURES', 'dsp', True, False, d)]} \
```