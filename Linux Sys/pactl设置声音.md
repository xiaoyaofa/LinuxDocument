查看所有可用的音频输出设备
pactl list short sinks
查看音量
```
pactl get-sink-volume <sinks-id>
```
增加音量
```
pactl set-sink-volume <sinks-id> +5%
```
减少音量
```
pactl set-sink-volume <sinks-id> -5%
```
设置绝对音量
```
pactl set-sink-volume <sinks-id> 50%
```
查看静音状态
```
pactl get-sink-mute <sinks-id>
```
设置静音
```
pactl set-sink-mute <sinks-id> 1
```
切换静音状态
```
pactl set-sink-mute <sinks-id> toggle
```