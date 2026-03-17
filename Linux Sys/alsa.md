alsamixer
pactl list sinks | grep "Name:"

查看声卡的设置
amixer -c0
查看可用的混音控件
amixer controls
启用Lineout并取消静音
amixer set 'Lineout' on unmute
关闭Headphone并静音
amixer set 'Headphone' off mute
或者
```
amixer cset numid=<id> on
```
amixer set 'PCM' 50%

## 录音
```
arecord -D hw:0,0 -d 10 -f cd test.wav
```

## 保存配置
临时
alsactl store -f /var/lib/alsa/asound.state
永久
alsactl store -f /etc/asound.state

## asound.conf插件
/etc/asound.conf
```
ctl.sgtl5000 {
    name "Lineout"
    value on
}
```