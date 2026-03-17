在ubuntu20.04中，qemu的glibc版本不一致
## 方法一
build-xwayland/tmp/work/x86_64-linux/qemu-native/4.1.0-r0/qemu-4.1.0/linux-user/syscall.c
找到
```
#ifdef TARGET_NR_stime /* not on alpha */
    case TARGET_NR_stime:
        {
            time_t host_time;
            if (get_user_sal(host_time, arg1))
                return -TARGET_EFAULT;
            return get_errno(stime(&host_time));
        }
#endif
```
改为
```
#ifdef TARGET_NR_stime /* not on alpha */
    case TARGET_NR_stime:
        {
            time_t host_time;
            if (get_user_sal(host_time, argl))
                return -TARGET_EFAULT;
            struct timespec res;
            res.tv_sec = host_time;
            return get_errno(clock_settime(CLOCK_REALTIME, &res));
        }
#endif
```
## 方法二
glibc降级