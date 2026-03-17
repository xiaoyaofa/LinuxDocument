## fbdev
weston --tty=7 --device=/dev/fb0 --use-g2d=1 --backend=fbdev-backend.so
weston --tty=7 --device=/dev/fb0 --backend=fbdev-backend.so


## 配置
vi /etc/xdg/weston/weston.ini
### 旋转
normal               Normal output.
rotate-90            90 degrees clockwise.
rotate-180           Upside down.
rotate-270           90 degrees counter clockwise.
flipped              Horizontally flipped
flipped-rotate-90    Flipped and 90 degrees clockwise
flipped-rotate-180   Flipped and upside down
flipped-rotate-270   Flipped and 90 degrees counter clockwise
```
[output]
name=HDMI-A-1
#mode=1280x720@60
mode=current
transform=rotate-90

```
### 背景
```
[shell]
panel-position=none     #表示面板工具栏的位置，这里设置为none,表示没有该面板工具栏
background-color=0x00FFFFFF        #表示背景颜色，0x00FFFFFF，表示完全透明
cursor-size=24          #游标大小
background-image=path/to/your/image.png          #背景图片
```
完整教程
https://man.archlinux.org/man/weston.ini.5.html