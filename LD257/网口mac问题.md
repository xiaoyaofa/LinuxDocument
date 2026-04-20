根据mmc的uuid生成mac地址
```
#!/bin/bash
serialnum=`blkid /dev/mmcblk1`
md5num=`echo -n $serialnum | md5sum | awk '{print $1}'`
echo md5num
eth0_mac=14:9a:${md5num:8:2}:${md5num:6:2}:${md5num:4:2}:${md5num:2:2}
echo $eth0_mac
ifconfig end1 down
ifconfig end1 hw ether $eth0_mac
ifconfig end1 up
```