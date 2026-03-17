htotal: hactive + hback-porch + hfront-porch + hsync-len
vtotal: vactive + vback-porch + vfront-porch + vsync-len
htotal * vtotal * fps = clock-frequency
Horizontal display area +  HS Blanking  = HS period time
Vertical display area  +   HS Blanking  =  VS period time

"HS Blanking" Hsync Blanking 水平同步消隐 = HS Pulse Width + HS Back Porch
"VS Blanking" Vsync Blanking 垂直同步消隐 = VS Pulse Width + VS Back Porch
```
clock-frequency = <71100000>;
hactive = <1280>;
hsync-len = <10>;
hback-porch = <80>;
hfront-porch = <70>;
vactive = <800>;
vsync-len = <5>;
vback-porch = <10>;
vfront-porch = <10>;
vsync-active = <0>;
hsync-active =<0>;
de-active =<0>;
pixelclk-active =<0>;
```
clock-frequency = (hactive + hsync-len + hback-porch + hfront-porch) * (vactive + vsync-len + vback-porch + vfront-porch) * freme

必须属性
```
hactive, vactive：显示分辨率。
hfront-porch, hback-porch, hsync-len：水平显示时序参数（以像素为单位）。
vfront-porch, vback-porch, vsync-len：垂直显示时序参数（以像素为单位）。
clock-frequency：显示时钟（以 Hz 为单位）。
```
可选属性
```
hsync-active：hsync 脉冲有效状态值 low/high/ignored。
vsync-active：vsync 脉冲有效状态值 low/high/ignored。
de-active：data-enable 脉冲有效状态值 low/high/ignored。
pixelclk-active：
高电平有效：上升沿更新数据，下降沿采集数据。
低电平有效：下降沿更新数据，上升沿采集数据。
interlaced (bool)：用于启用隔行扫描模式的布尔值。
doublescan (bool)：用于启用双扫描模式的布尔值。
doubleclk (bool)：启用双时钟模式的布尔值。
data-mapping：LVDS数据映射类型。有jeida（传统标准）、vesa、spwg格式。
JEIDA是一种常见的数据映射格式，RGB数据的高位（MSB）在LVDS信号对中靠前。R[7:2], G[7:2], B[7:2]（每个通道只使用6位有效数据）
VESA标准是一种更新的映射格式，RGB数据的低位（LSB）靠前，高位靠后。R[7:0], G[7:0], B[7:0]（完整8位色深支持）
SPWG标准
data-mirror：镜像翻转
```
参数定义
```
  +----------+-------------------------------------+----------+-------+
  |          |        ↑                            |          |       |
  |          |        |vback_porch                 |          |       |
  |          |        ↓                            |          |       |
  +----------#######################################----------+-------+
  |          #        ↑                            #          |       |
  |          #        |                            #          |       |
  |  hback   #        |                            #  hfront  | hsync |
  |   porch  #        |       hactive              #  porch   |  len  |
  |<-------->#<-------+--------------------------->#<-------->|<----->|
  |          #        |                            #          |       |
  |          #        |vactive                     #          |       |
  |          #        |                            #          |       |
  |          #        ↓                            #          |       |
  +----------#######################################----------+-------+
  |          |        ↑                            |          |       |
  |          |        |vfront_porch                |          |       |
  |          |        ↓                            |          |       |
  +----------+-------------------------------------+----------+-------+
  |          |        ↑                            |          |       |
  |          |        |vsync_len                   |          |       |
  |          |        ↓                            |          |       |
  +----------+-------------------------------------+----------+-------+
```