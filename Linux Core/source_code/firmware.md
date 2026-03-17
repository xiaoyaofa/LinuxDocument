## 固件子系统
request_firmware()：将固件以二进制文件形式存储于文件系统之中，在内核启动后再从用户空间将固件传递至内核空间，内核空间解析固件获得文件数据，最后加载至硬件设备

## struct firmware
```
struct firmware {
	size_t size;
	const u8 *data;

	/* firmware loader private fields */
	void *priv;
};
```

## request_firmware
函数原型
```
int request_firmware(const struct firmware **fw, const char *name,
		     struct device *device);
```
fw：用于保存申请到的固件数据
name:固件名字
device:申请固件的设备
如果申请固件成功，函数返回0；申请固件失败，返回一个负数值（如-EINVAL、-EBUSY）。

### 调用
调用request_firmware()时，函数在 /sys/class/firmware 下创建一个以设备名为目录名的新目录，其中包含 3 个属性:
loading:当固件加载时被置1，加载完毕被置0，如果被置-1则终止固件加载；
data:内核获取固件接口，当loading被置1时，用户空间通过该属性接口传递固件至内核空间；
device:符号链接，链接至/sys/devices/下相关设备目录。
当sysfs接口创建完毕，uevent会配合将固件通过sysfs节点写入内核

### 使用注意
request_firmware()函数如果在probe()中使用会一直阻塞至文件系统挂载获取固件
所以一般需要在驱动中使用工作队列INIT_WORK()

### 例程
```
static int zl380tw_component_probe(struct snd_soc_component *snd) 
{
    const struct firmware *fw_app;

    ret = request_firmware(&fw_app, "/lib/firmware/mytest", snd->dev);
    if (ret) {
        dev_err(cmpt->dev, "fail to request app firmware\n");
        fw_app = NULL;
        return ret;
    }

    if (!ret) 
        ret = download_firmware(zl380tw->i2c, fw_app);
    
    if (!fw_app) 
        release_firmware(fw_app);

}

```

## request_firmware_nowait
request_firmware是以同步的方式进行固件升级，如果要求进行升级时不上下文不进行睡眠操作，那么会用到异步升级API来加载固件，实际上其在调用工作队列的方式进行固件升级
函数原型
```
int request_firmware_nowait(
	struct module *module, bool uevent,
	const char *name, struct device *device, gfp_t gfp, void *context,
	void (*cont)(const struct firmware *fw, void *context));
```
module :模块名
uevent :一般置为1
name :固件名
device :需要申请固件的设备
gfp :内核内存分配标志位，一般为GFP_KERNEL
context:用户自定义上下文数据
cont :回调函数

### 例程
```
void update_requset_fw_callback(const struct firmware *fw, void *context)
{  
    struct device *dev = context;

    if (fw != NULL) 
    {
	    /* 下载固件至硬件设备 */    
        download_firmware(fw, dev);
        /* 释放firmware结构体 */
	    release_firmware(fw);
    }
}
static ssize_t download_firmware_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) //sysfs属性存储函数
{
    const struct firmware *fw = NULL;
    ret = request_firmware_nowait(THIS_MODULE, 1, "/lib/firmware/mytest", 
          dev, GFP_KERNEL, dev, update_requset_fw_callback);
	if (ret) 
	{
        return -ENOENT;
    }
    return ret;
}
```

## download_firmware
request_firmware用于申请固件数据，但是将固件下载到对应的设备需要自己实现
以i2c设备来举例，自定义下载函数
```
static int download_firmware(struct i2c_client * i2c, const struct firmware * fw_app)
```
然后在 request_firmware 后调用 download_firmware


## release_firmware
固件加载成功之后，需要释放固件
void release_firmware(const struct firmware *fw);
