目录 /etc/udev/rules.d/

查看设备节点的udev属性
udevadm info /dev/xxx

键盘udev规则
vi /etc/udev/rules.d/99-keyboard.rules
```
SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT_KEYBOARD}=="1", SYMLINK+="input/keyboard"
```

重新加载规则
udevadm control --reload-rules
udevadm trigger