#!/bin/sh
TOUCH_PATH=/sys/devices/platform/bus@f0000/20010000.i2c/i2c-2/2-0038/input/input1/event1

if [ -e /usr/share/calibrator.txt ]; then
    test=$(cat /usr/share/calibrator.txt)

    if [ -z "$test" ]; then
        rm /usr/share/calibrator.txt
        echo "Del"
    else
        echo "OK"
    fi
else
    echo "None!"
fi
sleep 3
if [ ! -e "/usr/share/calibrator.txt" ];then
weston-touch-calibrator -v $TOUCH_PATH > /usr/share/calibrator.txt
calibrationvalue=`cat /usr/share/calibrator.txt | awk -F ':' '{print $2}'`
echo 'SUBSYSTEM=="input", KERNEL=="event[0-9]*", ENV{ID_INPUT_TOUCHSCREEN}=="0", ENV{LIBINPUT_CALIBRATION_MATRIX}="'$calibrationvalue'"' >> /etc/udev/rules.d/touchscreen.rules
fi
sync

# SUBSYSTEM=="input", KERNEL=="event[0-9]*", ENV{ID_INPUT_TOUCHSCREEN}=="1", ENV{LIBINPUT_CALIBRATION_MATRIX}=" 62.651356 -4.917091 0.022950 5.632318 119.195145 -0.090358"