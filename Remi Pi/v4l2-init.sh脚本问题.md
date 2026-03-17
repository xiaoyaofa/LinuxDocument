修改
```
media-ctl -d /dev/media0 -V "'ov5645 0-003c':0 [fmt:UYVY8_2X8/$ov5645_res field:none]"
```
为
```
media-ctl -d /dev/media0 -V "'ov5640 0-003c':0 [fmt:UYVY8_2X8/$ov5645_res field:none]"
```