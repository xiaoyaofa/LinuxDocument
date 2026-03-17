rtc设备树
compatible = "ti,am62-rtc"
改为
compatible = "epson,rx8025t"
aliases节点增加
```
rtc0 = &rtc;
```