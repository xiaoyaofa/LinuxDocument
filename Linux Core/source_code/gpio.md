## 全局变量
```
static int major = 0;
static struct class *gpioctr_class;
static struct gpio_desc *gpioctr_gpio;
```
## 定义platform_driver
```
static struct platform_driver chip_demo_gpio_driver = {
    .probe = chip_demo_gpio_probe,
    .remove = chip_demo_gpio_remove,
    .driver = {
        .name = "myir_gpioctr",
        .of_match_table = myir_gpioctr, 
    }, 
};
```
## probe
设备树中定义有: xxx-gpios=<...>;
```
gpioctr_gpio = gpiod_get(&pdev->dev, "xxx", 0);
if (IS_ERR(gpioctr_gpio)) {
        dev_err(&pdev->dev, "Failed to get GPIO for led\n");
        return PTR_ERR(gpioctr_gpio);
    }
```
注册 file_operations
```
major = register_chrdev(0, "myir_gpioctr", &gpioctr_drv);
```
创建类
```
gpioctr_class = class_create(THIS_MODULE, "myir_gpioctr_class");
if (IS_ERR(gpioctr_class)) {
    printk("%s %s line %d\n", __FUNCTION__, __LINE__);
    unregister_chrdev(major, "gpioctr");
    gpiod_put(gpioctr_gpio);
    return PTR_ERR(gpioctr_class);
}
```
创建设备节点
```
device_create(gpioctr_class, NULL, MKDEV(major, 0), NULL, "myir_gpioctr%d", 0);
```
## remove
```
device_destroy(gpioctr_class, MKDEV(major, 0));
class_destroy(gpioctr_class);
unregister_chrdev(major, "myir_gpioctr");
gpiod_put(gpioctr_gpio);
```

## 实现对应的 open/read/write等函数，填入 file_operations 结构体
/* 定义自己的 file_operations 结构体*/
static struct file_operations gpioctr_drv = {
    .owner = THIS_MODULE,
    .open = gpio_drv_open,
    .read = gpio_drv_read,
    .write = gpio_drv_write,
    .release = gpio_drv_close, 
};