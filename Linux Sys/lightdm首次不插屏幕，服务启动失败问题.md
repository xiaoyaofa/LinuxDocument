systemctl status lightdm
```
root@jke2023:~# systemctl status lightdm
● lightdm.service - Light Display Manager
     Loaded: loaded (/lib/systemd/system/lightdm.service; indirect; vendor preset: enabled)
     Active: activating (auto-restart) (Result: exit-code) since Wed 2025-10-22 15:50:58 CST; 3s ago
       Docs: man:lightdm(1)
    Process: 3252 ExecStartPre=/bin/sh -c [ "$(basename $(cat /etc/X11/default-display-manager 2>/dev/null))" = "lightdm" ] (code=exited, status=0/SUCCESS)
    Process: 3255 ExecStart=/usr/sbin/lightdm (code=exited, status=1/FAILURE)
   Main PID: 3255 (code=exited, status=1/FAILURE)
```
