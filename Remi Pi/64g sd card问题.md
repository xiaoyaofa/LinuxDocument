可能是SD卡在上电的时候出现电源还没有稳定，需要增大上电等待的延迟

修改drivers/mmc/core/core.c

host->ios.power_delay_ms打印出来是10ms

修改如下
```
void mmc_power_up(struct mmc_host *host, u32 ocr)
{
······
/*
 * This delay should be sufficient to allow the power supply
 * to reach the minimum voltage.
 */
//  mmc_delay(host->ios.power_delay_ms);
mmc_delay(100);
```
```
······
/*
 * This delay must be at least 74 clock sizes, or 1 ms, or the
 * time required to reach a stable voltage.
 */
 // mmc_delay(host->ios.power_delay_ms);
mmc_delay(100);
······
}
```
将延时增加到100ms(对wifi有影响)