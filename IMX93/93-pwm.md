
```
&iomuxc {
	pinctrl_tpm4: tpm4grp {
		fsl,pins = <
            MX93_PAD_GPIO_IO05__TPM4_CH0	0x19e
		>;
	};
}

&tpm4 {
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_tpm4>;
	status = "okay";
};
```
max = 10Khz

10Khz
echo 1 > /sys/class/pwm/pwmchip0/export
echo 100000 > /sys/class/pwm/pwmchip0/pwm1/period
echo 50000 > /sys/class/pwm/pwmchip0/pwm1/duty_cycle
echo "normal" > /sys/class/pwm/pwmchip0/pwm1/polarity
echo 1 > /sys/class/pwm/pwmchip0/pwm1/enable
echo 0 > /sys/class/pwm/pwmchip0/pwm1/enable

2Khz
echo 500000 > /sys/class/pwm/pwmchip0/pwm1/period
echo 250000 > /sys/class/pwm/pwmchip0/pwm1/duty_cycle

500Hz
echo 2000000 > /sys/class/pwm/pwmchip0/pwm0/period
echo 1000000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle