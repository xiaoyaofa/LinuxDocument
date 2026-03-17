## 驱动
### widget
snd_soc_dapm_widget
```
MIXER：多个输入源混合成一个输出，用SND_SOC_DAPM_MIXER定义这个widget，类型为snd_soc_dapm_mixer；
MUX：多路选择器，多路输入，但只能选择一路作为输出，用SND_SOC_DAPM_MUX定义这个widget，类型为snd_soc_dapm_mux；
PGA：单路输入，单路输出，带gain调整的部件，用SND_SOC_DAPM_PGA定义这个widget，类型为snd_soc_dapm_pga。
```
例
```

/* Input */
SND_SOC_DAPM_MIXER("Left Input Mixer", WM8900_REG_POWER2, 5, 0,
		   wm8900_linmix_controls,
		   ARRAY_SIZE(wm8900_linmix_controls)),
/* Output */
SND_SOC_DAPM_MIXER("Left Output Mixer", WM8900_REG_POWER3, 3, 0,
		   wm8900_loutmix_controls,
		   ARRAY_SIZE(wm8900_loutmix_controls)),
```
### route
snd_soc_dapm_route
用于搭建音频路径
```
{"Left Output Mixer", "Left Input Mixer Switch", "Left Input Mixer"},
```
前面的"Left Output Mixer"表示操作目的对象sink，对应widgets中的名为Left Output Mixer的widget；

中间的"Left Input Mixer Switch"表示操作行为control，对应wm8900_loutmix_controls中的名为Left Input Mixer Switch的kcontrol；

后面的"Left Input Mixer"表示操作源对象source，对应widgets中的名为Left Input Mixer的widget。

合起来的意思：通过动作"Left Input Mixer Switch"将输入源"Left Input Mixer"送到目的混合器"Left Output Mixer"输出。

kcontrols
```
```

## 设备树
compatible="simple-audio-card"
```
simple-audio-card,name          :声卡名称
simple-audio-card,widgets       :每个条目都是一对字符串:"template-wname"，"user-supplied-wname"
"template-wname"是模板小部件名称，可选为："Microphone", "Lineout", "Headphone", "Speaker"
"user-supplied-wname"是用户重命名小部件后的名称

simple-audio-card,routing       :音频组件之间的连接列表。每个条目都是一对字符串，第一个是目的(sink)，第二个是源(source)
```
### 举例
```
simple-audio-card,widgets = "Microphone", "HeadphoneMic",
					 "Microphone", "Main Mic";
为"HeadphoneMic"的widget被重命名为"Microphone"
等价于驱动里
static const struct snd_soc_dapm_widget sunxi_card_dapm_widgets[] = {
	SND_SOC_DAPM_MIC("HeadphoneMic", NULL),
	SND_SOC_DAPM_MIC("Main Mic", NULL),
};
snd_soc_dapm_new_controls(dapm, sunxi_card_dapm_widgets,
				ARRAY_SIZE(sunxi_card_dapm_widgets));
```
```
simple-audio-card,routing = "MainMic Bias", "Main Mic",
					"MIC1", "MainMic Bias",
					"MIC2", "HeadphoneMic";
将名字为"Main Mic"的widget连接到名字为"MainMic Bias"的widget
将名字为"MainMic Bias"的widget连接到名字为"MIC1"的widget
将名字为"HeadphoneMic"的widget连接到名字为"MIC2"的widget

等价于驱动里
static const struct snd_soc_dapm_route sunxi_card_routes[] = {
	{"MainMic Bias", NULL, "Main Mic"},
	{"MIC1", NULL, "MainMic Bias"},
	{"MIC2", NULL, "HeadphoneMic"},
};
snd_soc_dapm_add_routes(dapm, sunxi_card_routes,
				ARRAY_SIZE(sunxi_card_routes));

```

## 参考链接
https://blog.csdn.net/azloong/article/details/6334922