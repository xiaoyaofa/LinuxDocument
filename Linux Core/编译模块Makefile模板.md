```
#模块名字
obj-m += xxx.o

#内核源码目录
KERNELDIR := 

all:
	make -C $(KERNELDIR) M=$(PWD) modules

clean:
	make -C $(KERNELDIR) M=$(PWD) clean
```