arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
修改结构体中的.flag
```
struct omap_hwmod am33xx_l3_main_hwmod

.flags		= HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET,
```
arch/arm/mach-omap2/omap_hwmod_33xx_data.c
```
static struct omap_hwmod am33xx_lcdc_hwmod

.flags		= HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET,
```
让kernel不初始化lcd