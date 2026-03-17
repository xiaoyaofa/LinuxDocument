内核里面默认是把uvcvideo编译成模块，应该会生成uvcvideo.ko的依赖模块
但是videobuf2-vmalloc.ko这个模块没有生成。
make menuconfig
```
-> Device Drivers  
    -> Multimedia support
        -> Media drivers  
            -> Media USB Adapters
                <M>   USB Video Class (UVC)
```
```
<*>   USB Video Class (UVC)
```