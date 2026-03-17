## 修改源码
drivers/video/backlight/pwm_bl.c

添加任务进程全局变量
```
static struct task_struct *bl_delay_task;
```
修改static int pwm_backlight_update_status(struct backlight_device *bl)
**注释之间是修改部分**
```
···
int duty_cycle;
//----------flag------------
static uint8_t flag = 1;
//-----------flag-----------

···

if (pb->notify)
		brightness = pb->notify(pb->dev, brightness);
	// printk("\n-----%s-----pwm_backlight_update_status-----------\n", __FILE__);
	//------first-----close_backlight---------
	if (flag)
	{
		pwm_backlight_power_off(pb);
		flag = 0;
		if (pb->notify_after)
			pb->notify_after(pb->dev, brightness);
		return 0;
	}
	//------first-----close_backlight---------
···

```
添加bl_on_fuction函数
```
// ----------bl_sleep----------
int bl_on_fuction(void *arg)
{
	struct backlight_device *bl;
	bl = (struct backlight_device *)arg;
 
	// printk("----------------[bgk] bl_on gpio before msleep------------------ \n");
	msleep(2000);
 
	bl->props.power = 0;  // open bl
	backlight_update_status(bl);
 
	// printk("---------------[bgk] bl_on gpio after msleep--------------------- \n");
 
	return 0;
}
// ----------bl_sleep----------
```
修改static int pwm_backlight_probe(struct platform_device *pdev)
```

···
	//-----------bl_delay_task----------
	bl_delay_task = kthread_create(bl_on_fuction, bl, "bl_delay");
	if(IS_ERR(bl_delay_task))
	{
		printk("[bgk] bl_on kthread_create Unable to start kernel thread. \n");
		err = PTR_ERR(bl_delay_task);
		bl_delay_task = NULL;
		goto err_thread;
	}
	wake_up_process(bl_delay_task);
	//-----------bl_delay_task----------

	return 0;
//--------err_thread-----
err_thread:
	return 0;
//-------err_thread------

err_alloc:
	if (data->exit)
		data->exit(&pdev->dev);
	return ret;
···

```
修改static int pwm_backlight_remove(struct platform_device *pdev)
```

	backlight_device_unregister(bl);
	pwm_backlight_power_off(pb);

	//----------bl_delay_task_remove----------
	if (bl_delay_task)
	{
		kthread_stop(bl_delay_task);
		bl_delay_task = NULL;
	}
	//----------bl_delay_task_remove----------
```