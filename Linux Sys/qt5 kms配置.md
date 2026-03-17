export QT_QPA_EGLFS_ALWAYS_SET_MODE="1"
export QT_QPA_EGLFS_INTEGRATION="eglfs_kms"
export QT_QPA_EGLFS_KMS_CONFIG="/etc/qt5/eglfs_kms_cfg.json"


/etc/qt5/eglfs_kms_cfg.json
```
{
  "device": "/dev/dri/card1",
  "hwcursor": false,
  "pbuffers": true
}
```