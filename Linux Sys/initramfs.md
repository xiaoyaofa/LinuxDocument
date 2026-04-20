yocto编译core-image-tiny-initramfs
## 启动cpio
uboot启动参数(nand)
```
ubi part UBI boot; ubifsmount ubi0:boot;
ubifsload ${kernel_addr_r} uImage;ubifsload ${fdt_addr_r} xxx.dtb;
ubifsload ${ramdisk_addr_r} core-image-tiny-initramfs.cpio.gz;
```
```
setenv bootargs "loglevel=${loglevel} console=${console},${baudrate} initrd=${ramdisk_addr_r},0x${filesize} rdinit=/init earlyprintk debugshell=0"
```
如果用
```
setenv bootargs "loglevel=${loglevel} console=${console},${baudrate} initrd=${ramdisk_addr_r},0x${filesize} rdinit=/init earlyprintk"
```

## 修改cpio
### 解压cpio
```
cpio -idmv < ../xxx.cpio
```
### 打包成cpio
```
find . | sort | cpio --reproducible -o -H newc -R root:root > ../core-image.cpio
```
### 压缩
```
gzip -v9 -f core-image.cpio
```