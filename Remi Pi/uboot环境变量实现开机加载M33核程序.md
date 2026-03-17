```
setenv bootcmd "run sd_load_check;run bootcmd_check;run bootimage;"
setenv sd_load_check "switch_sdhi1 sdcard;if fatload mmc 1:1 0x0001FF80 rzg2l_cm33_rpmsg_demo_secure_vector.bin; then run sd_load; fi"
setenv sd_load "switch_sdhi1 sdcard;ls mmc 1:1;dcache off;mmc dev 1;if fatload mmc 1:1 0x0001FF80 rzg2l_cm33_rpmsg_demo_secure_vector.bin;fatload mmc 1:1 0x42EFF440 rzg2l_cm33_rpmsg_demo_secure_code.bin;fatload mmc 1:1 0x00010000 rzg2l_cm33_rpmsg_demo_non_secure_vector.bin;fatload mmc 1:1 0x40010000 rzg2l_cm33_rpmsg_demo_non_secure_code.bin;then cm33 start_debug 0x1001FF80 0x00010000;dcache on;fi"
saveenv
```
恢复默认值
```
env default -a;saveenv;
```