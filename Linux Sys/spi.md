## 导出节点
手动导出/dev/spi0.0节点，给spi
```
echo spidev > /sys/bus/spi/devices/spi0.0/driver_override
echo spi0.0 > /sys/bus/spi/drivers/spidev/bind
```