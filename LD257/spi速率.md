```
计算	133MHz / 500kHz = 266 > max_div(256)
最低可用频率	133MHz / 256 ≈ 520kHz
spi clk 需要改为 1MHz（或 520kHz~66.5MHz 之间任意值
```