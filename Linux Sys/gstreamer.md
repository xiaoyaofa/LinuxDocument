## gst-inspect-1.0
列出所有插件
gst-inspect-1.0
删除缓存，重新扫描插件
```
rm ~/.cache/gstreamer-1.0/registry.aarch64.bin
gst-inspect-1.0 > /dev/null
```

## 捕获视频
```
gst-launch-1.0 v4l2src ! \
videoconvert ! \
x264enc ! \
mp4mux ! filesink location=output.mp4
```

## 循环播放
转换成h264的流
```
gst-launch-1.0 -e filesrc location=test.mp4 \
  ! qtdemux name=demux demux.video_0 \
  ! h264parse \
  ! video/x-h264,stream-format=byte-stream \
  ! filesink location=test-notime.h264
```
```
gst-launch-1.0 multifilesrc location=test-notime.h264 loop=true \
  ! h264parse \
  ! avdec_h264 \
  ! videoconvert \
  ! waylandsink
```

## 播放音频
播放音频，指定数据格式
```
gst-launch-1.0 filesrc location=song.wav ! audio/x-raw,channels=2,rate=44100,format=S16LE ! alsasink device=hw:0,0
```
原始16khz音频转换为48khz播放
```
gst-launch-1.0 filesrc location=farEnd.wav ! \
		audio/x-raw,channels=1,rate=16000,format=S16LE,layout=interleaved ! \
		audioconvert ! \
		audioresample ! \
		audio/x-raw,channels=2,rate=48000,format=S16LE ! \
		alsasink device=hw:0,0
```

## 录音
列出可用的音频设备
```
gst-device-monitor-1.0 Audio/Source
```

## 播放摄像头
### USB摄像头
wayland
```
gst-launch-1.0 v4l2src device=/dev/video0 ! image/jpeg,width=1280,height=720,framerate=30/1   ! jpegdec ! videoconvert ! waylandsink
```
FB
```
gst-launch-1.0 v4l2src device=/dev/video0 ! image/jpeg,width=1280,height=720,framerate=30/1   ! jpegdec ! videoconvert ! fbdevsink device=/dev/fb0
```
保存成jpeg流格式
```
gst-launch-1.0 v4l2src device=/dev/video0 \
  ! image/jpeg,width=1280,height=720,framerate=30/1 \
  ! filesink location=/root/720p-30fps.mjpeg
```
播放jpeg流格式
```
gst-launch-1.0 filesrc location=/root/720p-30fps.mjpeg \
  ! jpegdec ! videoconvert \
  ! videorate ! video/x-raw,framerate=30/1 \
  ! waylandsink
```
调试参数
增加帧数显示
```
gst-launch-1.0 v4l2src device=/dev/video0 ! image/jpeg,width=1280,height=720,framerate=30/1 ! jpegdec ! videoconvert ! fpsdisplaysink video-sink=waylandsink text-overlay=true sync=true
```

