内核配置
```
CONFIG_TEE=y
CONFIG_OPTEE=y
```
若出现 /dev/tee0 和 /dev/teepriv0 节点，说明optee v2的TEE linux kernel驱动已开启