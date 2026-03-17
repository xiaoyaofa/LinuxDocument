## 修改设备树
&pinctrl中添加
```
gpt3_pins: gpt3 {
		pinmux = <RZG2L_PORT_PINMUX(19, 1, 2)>; /* Channel B */
};
```
文件最后添加
```
&gpt3 {
	pinctrl-0 = <&gpt3_pins>;
	pinctrl-names = "default";
	channel = "channel_B";
	status = "okay";
};
```
## 验证
查看生成节点
```
ls /sys/class/pwm
```
生成失败
```
pwmchip0
```
生成成功有2个,此时pwmchip0是gpt3的pwm
```
pwmchip0  pwmchip1
```
因为背光使用的gpt4的pwm，所以pwm总是最大那一个

### 操作PWM
```
echo 0 > /sys/class/pwm/pwmchip0/export
echo 1000000 > /sys/class/pwm/pwmchip0/pwm0/period      #周期设置1KHZ
echo 500000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle   #占空比
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable            #使能 PWM 输出
```
单位为ns，即一个周期为1KHZ

### 设置AB双通道
channel = "both_AB";

操作占空比的地方变成
/sys/class/pwm/pwmchip0/device/buffB0 
或device/buffA0