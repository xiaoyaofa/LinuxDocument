设备树
arch/arm/dts/myb-am62x-dev.dts
```
panel_lvds: panel-lvds {
    bootph-pre-ram;
    compatible = "simple-panel";
    status= "okay";
    width-mm = <154>;
    height-mm = <85>;
    data-mapping = "vesa-24";
    panel-timings {
        bootph-pre-ram;
        clock-frequency = <75000>;
        hactive = <1024>;
        hfront-porch = <88>;
        hsync-len = <6>;
        hback-porch = <176>;
            
        vactive = <600>;
        vfront-porch = <25>; 
        vsync-len = <5>;
        vback-porch = <20>;
        
        hsync-active = <0>;
        vsync-active = <1>;
        de-active = <1>;
        pixelclk-active = <0>;
    };
    port@0 {
        // dual-lvds-odd-pixels;
        lcd_in0: endpoint {
            remote-endpoint = <&oldi_out0>;
        };
    };
};
&mcu_pmx0 {
    ···
    mcu_lvds_power_pins_default: mcu-lvds-power-pins-default {
		pinctrl-single,pins = <
			AM62X_MCU_IOPAD(0x0010, PIN_OUTPUT_PULLUP, 7) /* (C9) MCU_SPI0_D1.MCU_GPIO0_4 */
		>;
	};
    ···
};
&mcu_gpio0 {
	pinctrl-names ="default";
	pinctrl-0=<
			&mcu_lvds_power_pins_default
			>;
	status = "okay";
};
&main_pmx0 {
    ···
    main_oldi0_pins_default: main-oldi0-pins-default {
		pinctrl-single,pins = <
			AM62X_IOPAD(0x0260, PIN_OUTPUT, 0) /* (AA5) OLDI0_A0N */
			AM62X_IOPAD(0x025c, PIN_OUTPUT, 0) /* (Y6) OLDI0_A0P */
			AM62X_IOPAD(0x0268, PIN_OUTPUT, 0) /* (AD3) OLDI0_A1N */
			AM62X_IOPAD(0x0264, PIN_OUTPUT, 0) /* (AB4) OLDI0_A1P */
			AM62X_IOPAD(0x0270, PIN_OUTPUT, 0) /* (Y8) OLDI0_A2N */
			AM62X_IOPAD(0x026c, PIN_OUTPUT, 0) /* (AA8) OLDI0_A2P */
			AM62X_IOPAD(0x0278, PIN_OUTPUT, 0) /* (AB6) OLDI0_A3N */
			AM62X_IOPAD(0x0274, PIN_OUTPUT, 0) /* (AA7) OLDI0_A3P */
			AM62X_IOPAD(0x0280, PIN_OUTPUT, 0) /* (AC6) OLDI0_A4N */
			AM62X_IOPAD(0x027c, PIN_OUTPUT, 0) /* (AC5) OLDI0_A4P */
			AM62X_IOPAD(0x0288, PIN_OUTPUT, 0) /* (AE5) OLDI0_A5N */
			AM62X_IOPAD(0x0284, PIN_OUTPUT, 0) /* (AD6) OLDI0_A5P */
			AM62X_IOPAD(0x0290, PIN_OUTPUT, 0) /* (AE6) OLDI0_A6N */
			AM62X_IOPAD(0x028c, PIN_OUTPUT, 0) /* (AD7) OLDI0_A6P */
			AM62X_IOPAD(0x0298, PIN_OUTPUT, 0) /* (AD8) OLDI0_A7N */
			AM62X_IOPAD(0x0294, PIN_OUTPUT, 0) /* (AE7) OLDI0_A7P */
			AM62X_IOPAD(0x02a0, PIN_OUTPUT, 0) /* (AD4) OLDI0_CLK0N */
			AM62X_IOPAD(0x029c, PIN_OUTPUT, 0) /* (AE3) OLDI0_CLK0P */
			AM62X_IOPAD(0x02a8, PIN_OUTPUT, 0) /* (AE4) OLDI0_CLK1N */
			AM62X_IOPAD(0x02a4, PIN_OUTPUT, 0) /* (AD5) OLDI0_CLK1P */
		>;
    };
    ···
};
&dss_ports {
	#address-cells = <1>;
	#size-cells = <0>;
	/* VP1: LVDS Output (OLDI TX 0) */
	port@0 {
		reg = <0>;
		oldi_out0: endpoint {
			remote-endpoint = <&lcd_in0>;
		};
	};
	/* VP1: LVDS Output (OLDI TX 1) */
	// port@2 {
	// 	reg = <2>;
	// 	oldi_out1: endpoint {
	// 		remote-endpoint = <&lcd_in1>;
	// 	};
	// };
};
&dss {
	pinctrl-names = "default";
	pinctrl-0 = <&main_oldi0_pins_default &main_dss0_pins_default>;
};
```
board/myir/myc_am62x/som.c
可以修改lvds power启动时间
```
static void gpio_rst_and_power(void)
```
修改结构体，devpart，修改加载uboot logo的位置
```
static struct splash_location default_splash_locations[] = {
	{
		.name = "sf",
		.storage = SPLASH_STORAGE_SF,
		.flags = SPLASH_STORAGE_RAW,
		.offset = 0x700000,
	},
	{
		.name		= "mmc",
		.storage	= SPLASH_STORAGE_MMC,
		.flags		= SPLASH_STORAGE_FS,
		.devpart	= "0:1",
	},
};
```
设置lvds模式为单连接模式
drivers/video/tidss/tidss_drv.c
```
static int tidss_drv_probe(struct udevice *dev)
    ···
	if (priv->feat->subrev == DSS_AM65X || priv->feat->subrev == DSS_AM625) {
		priv->oldi_mode = OLDI_DUAL_LINK;
		/* edit by xie */
		printf("--priv->oldi_mode=%d--\n", priv->oldi_mode);
		priv->oldi_mode = OLDI_SINGLE_LINK_SINGLE_MODE;
		/* end */
		if (priv->oldi_mode)
		{
			ret = dss_init_am65x_oldi_io_ctrl(dev, priv);
			if (ret)
				return ret;
		}
	}
    ···
```
