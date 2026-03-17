## 移植
所有--sysroot --datadir 改成自己sdk的sysroot位置
--prefix 安装位置
```
./configure --disable-stripping --enable-pic --enable-shared --enable-pthreads --cross-prefix=aarch64-poky-linux- --ld='aarch64-poky-linux-gcc -mtune=cortex-a55 -fstack-protector-strong -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Werror=format-security --sysroot=/home/lubancat/SDK/g2l-sdk/sysroots/aarch64-poky-linux' --cc='aarch64-poky-linux-gcc -mtune=cortex-a55  -fstack-protector-strong -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Werror=format-security --sysroot=/home/lubancat/SDK/g2l-sdk/sysroots/aarch64-poky-linux' --cxx='aarch64-poky-linux-g++ -mtune=cortex-a55 -fstack-protector-strong -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Werror=format-security --sysroot=/home/lubancat/SDK/g2l-sdk/sysroots/aarch64-poky-linux' --arch=aarch64 --target-os=linux --enable-cross-compile --extra-cflags=' -O2 -pipe -g -feliminate-unused-debug-types -fmacro-prefix-map==/usr/src/debug/ffmpeg/4.2.2-r0 -fdebug-prefix-map==/usr/src/debug/ffmpeg/4.2.2-r0 -fdebug-prefix-map=/recipe-sysroot= -fdebug-prefix-map=/recipe-sysroot-native= -mtune=cortex-a55 -fstack-protector-strong -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Werror=format-security --sysroot=/home/lubancat/SDK/g2l-sdk/sysroots/aarch64-poky-linux' --extra-ldflags='-Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed -fstack-protector-strong -Wl,-z,relro,-z,now' --sysroot=/home/lubancat/SDK/g2l-sdk/sysroots/aarch64-poky-linux --disable-mipsdsp --disable-mipsdspr2 --cpu=generic --pkg-config=pkg-config --disable-static --enable-alsa --enable-avcodec --enable-avdevice --enable-avfilter --enable-avformat --enable-avresample --enable-bzlib --disable-libfdk-aac --enable-gpl --disable-libgsm --disable-indev=jack --disable-libvorbis --enable-lzma --disable-libmfx --disable-libmp3lame --disable-openssl --enable-postproc --disable-sdl2 --disable-libspeex --enable-swresample --enable-swscale --enable-libtheora --disable-vaapi --disable-vdpau --disable-libvpx --enable-libx264 --disable-libx265 --disable-libxcb --disable-outdev=xv --enable-zlib --enable-omx --prefix=$PWD/install
```

ln -s /usr/lib64/libomxr_core.so.3.0.0 /usr/lib64/libOmxCore.so
## 摄像头
初始化摄像头
```
media-ctl -d /dev/media0 -r
media-ctl -d /dev/media0 -l "'rzg2l_csi2 10830400.csi2':1 -> 'CRU output':0 [1]"
media-ctl -d /dev/media0 -V "'rzg2l_csi2 10830400.csi2':1 [fmt:UYVY8_2X8/1920x1080 field:none]"
media-ctl -d /dev/media0 -V "'ov5640 0-003c':0 [fmt:UYVY8_2X8/1920x1080 field:none]"
```
软解码
```
ffmpeg -hide_banner -framerate 25 -i /dev/video0 -c:v libx264 out_video.mkv
```
硬解码
```
ffmpeg -hide_banner -framerate 30 -i /dev/video0 -c:v h264_v4l2m2m out_video.mkv
```

## 拉流测试
ffmpeg -stats -i "https://www.wowza.com/developer/rtsp-stream-test" -f null -
