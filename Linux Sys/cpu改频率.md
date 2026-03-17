## 查看cpu模式
```
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
```
performance ：始终使用最高频率，以获得最佳性能。
powersave ：通常以最低频率运行以节省能量，但可能影响性能。
ondemand ：根据负载动态调整频率，适合平衡性能与功耗。
schedutil :根据负载动态调整频率，适合平衡性能与功耗，频率切换比ondemand快
interactive ：在负载较高时迅速提高频率，在低负载时降低频率。
userspace ：允许用户手动设置频率，需要额外配置。
## 查看频率
```
cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
```
切换cpu模式
```
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
```