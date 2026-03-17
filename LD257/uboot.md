## 单独替换uboot问题

include/config_distro_bootcmd.h
```
boot_syslinux_conf=extlinux/myb-stm32mp257x-1GB_extlinux.conf
```

board/myir/myd_ld25x/myd-ld25x.c
```
int board_late_init(void)
{
    ···
    if (IS_ENABLED(CONFIG_ENV_VARS_UBOOT_RUNTIME_CONFIG)) {
		fdt_compat = fdt_getprop(gd->fdt_blob, 0, "compatible",
			&fdt_compat_len);

		// printf("fdt_compat=%s\n", fdt_compat);
		// printf("fdt_compat_len=%d\n", fdt_compat_len);

		char ddr1g_name[] = "myir,myb-stm32mp257x-1GB";
		fdt_compat = ddr1g_name;
		fdt_compat_len = 24;
		if (fdt_compat && fdt_compat_len)
		{
			if (strncmp(fdt_compat, "myir,", 5) != 0) {
				env_set("board_name", fdt_compat);
				// printf("---1---\n");
			} else
			{
				// printf("---2---\n");
				env_set("board_name", fdt_compat + 5);
				
				buf_len = sizeof(dtb_name);
				strncpy(dtb_name, fdt_compat + 3, buf_len);
				buf_len -= strlen(fdt_compat + 3);
				strncat(dtb_name, ".dtb", buf_len);
				env_set("fdtfile", dtb_name);
			}
		}
		env_set("boot_syslinux_conf", "extlinux/myb-stm32mp257x-1GB_extlinux.conf");
	}
    ···
}
```

## 去除uboot logo
取消CONFIG_VIDEO_STM32_LVDS这个宏定义