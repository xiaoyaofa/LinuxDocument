## gstreamer
### 编码测试
webm格式
```
gst-launch-1.0 videotestsrc num-buffers=300 ! video/x-raw, width=640, height=480, framerate=30/1 ! encodebin profile="video/x-vp8" ! matroskamux ! filesink location=v_vp8_640x480_30fps.webm
```
mp4格式
gst-launch-1.0 videotestsrc num-buffers=300 ! video/x-raw, width=640, height=480, framerate=30/1 ! encodebin profile="video/x-h264" ! qtmux ! filesink location=v_h264_640x480_30fps.mp4
### 解码测试
```
gst-launch-1.0 filesrc location=v_vp8_640x480_30fps.webm ! decodebin ! identity signal-handoffs=true ! videoconvert ! fpsdisplaysink video-sink="waylandsink"
```
### 转码测试
mp4 转换为 webm
```
gst-transcoder-1.0 myir.mp4 myir_vp8.webm webm
```


### 预览摄像头
linux6.1
```
/usr/bin/launch_camera_control_mp25.sh

gst-launch-1.0 v4l2src device=/dev/x_video ! video/x-raw, format=RGB16, width=640, height=480 ! queue !  gtkwaylandsink name=gtkwsink
```
linux6.6
```
gst-launch-1.0 libcamerasrc name=cs src::stream-role=view-finder cs.src ! video/x-raw, format=RGB16, width=640, height=480 ! queue !  gtkwaylandsink name=gtkwsink
```
### 硬件编码摄像头
```
gst-launch-1.0 -e v4l2src device=/dev/x_video ! video/x-raw, format=RGB16,width=640, height=480, framerate=30/1 ! encodebin profile="video/x-h264" ! h264parse ! video/x-h264,stream-format=avc,alignment=au ! qtmux ! queue ! filesink location=v_h264_640x480_30fps.mp4

gst-play-1.0 v_h264_640x480_30fps.mp4
```

### 参考
https://wiki.stmicroelectronics.cn/stm32mpu/wiki/V4L2_video_codec_overview


## ffmpeg
