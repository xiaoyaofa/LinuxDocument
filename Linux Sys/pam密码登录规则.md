主要依赖libpam libpwquality

vi /etc/pam.d/common-password
```
password requisite pam_pwquality.so retry=3 minlen=12 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1 enforce_for_root
```
pam_tally2.so 是一个用于 记录和限制用户登录失败次数 的 PAM 模块

vi /etc/pam.d/sshd
deny 允许的最大失败次数
unlock_time 账户锁定时间
even_deny_root 对root用户生效
```
auth  required  pam_tally2.so onerr=fail deny=3 unlock_time=30 even_deny_root root_unlock_time=30
```
```
account    required    pam_tally2.so
```