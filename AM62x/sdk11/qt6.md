export QT_QPA_EGLFS_KMS_CONFIG="/etc/eglfs_kms.json"
## 同显
vi /etc/eglfs_kms.json
```
{
  "device": "/dev/dri/card0",
  "hwcursor": false,
  "pbuffers": true,
  "outputs": [
    {
      "name": "HDMI1",
      "mode": "1280x720",
      "clones": "LVDS1"
    },
    {
      "name": "LVDS1",
      "mode": "1280x720"
    }
  ]
}
```
局限性HDMI和LVDS分辨率要一致，不然HDMI显示不全