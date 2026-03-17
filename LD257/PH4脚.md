## M核访问报错
PH4默认是bootrom，RIF的配置PH4默认只能由A35控制

修改optee
myir-st-optee/core/arch/arm/dts/myb-stm32mp257x-rif.dtsi
![alt text](./Picture/ph4-rif.png)

删除build目录，运行build-uboot-zh.sh脚本重新编译