## 设备树
```
&main_pmx0{
    main_epwm0_pins_default: main-epwm0-pins-default {
        pinctrl-single,pins = <
            AM62X_IOPAD(0x01b4, PIN_OUTPUT, 7) /* (A13) SPI0_CS0.EHRPWM0_A */
            AM62X_IOPAD(0x01b8, PIN_OUTPUT, 7) /* (C13) SPI0_CS1.EHRPWM0_B */
        >;
    };
}
&epwm0 {
	pinctrl-names = "default";
	pinctrl-0 = <&main_epwm0_pins_default>;
	status = "okay";
};
```
## 操作
echo 0 > /sys/class/pwm/pwmchip0/export
echo 1 > /sys/class/pwm/pwmchip0/export

echo 100000000 > /sys/class/pwm/pwmchip0/pwm0/period
echo 30000000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
echo "normal" > /sys/class/pwm/pwmchip0/pwm0/polarity
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable
echo 100000000 > /sys/class/pwm/pwmchip0/pwm1/period
echo 30000000 > /sys/class/pwm/pwmchip0/pwm1/duty_cycle
echo "normal" > /sys/class/pwm/pwmchip0/pwm1/polarity
echo 1 > /sys/class/pwm/pwmchip0/pwm1/enable
```
echo "normal" > /sys/class/pwm/pwmchip0/pwm0/polarity
inversed

/sys/kernel/debug/clk/epwm_tbclk0