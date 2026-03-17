## 内核配置
开启内存分配器调试，用于辅助开启kmemleak
```
CONFIG_SLUB_DEBUG=y
CONFIG_SLUB_DEBUG_ON=y
```
开启kmemleak
```
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE=32000
CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y
```

## 使用
开启自动扫描
```
echo scan=on > /sys/kernel/debug/kmemleak
```
关闭自动扫描
```
echo scan=off > /sys/kernel/debug/kmemleak
```
手动触发扫描
```
echo scan > /sys/kernel/debug/kmemleak
```
设置自动扫描间隔
```
echo scan=60 > /sys/kernel/debug/kmemleak
```
查看某个地址块信息
```
echo dump=<addr> > /sys/kernel/debug/kmemleak
```
查看完整泄漏报告
```
cat /sys/kernel/debug/kmemleak
```
清除报告
```
echo clear > /sys/kernel/debug/kmemleak
```
忽略指定地址
```
echo "ignore 0xc0a00000" > /sys/kernel/debug/kmemleak
```

