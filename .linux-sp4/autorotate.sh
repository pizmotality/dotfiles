#!/bin/bash

abs() {
    [ $1 -lt 0 ] && echo $((-$1)) || echo $1
}

twocp() {
    [ $1 -lt 32768 ] && echo $1 || echo $(($1-65536))
}

_DISPLAY=$(xrandr | grep -m 1 " connected" | cut -d' ' -f1)
_INPUTID=$(xinput list | grep 'ipts 1B96:006A  ' | awk -F '[=\t]' '{print $3}')

_LAST="normal"

while sleep 3; do
    # read from sensors
    _ACCEL_X_RAW=`cat /sys/bus/iio/devices/iio\:device*/in_accel_x_raw`
    _ACCEL_Y_RAW=`cat /sys/bus/iio/devices/iio\:device*/in_accel_y_raw`
    _ACCEL_Z_RAW=`cat /sys/bus/iio/devices/iio\:device*/in_accel_z_raw`

    _ACCEL_X=$(twocp $_ACCEL_X_RAW)
    _ACCEL_Y=$(twocp $_ACCEL_Y_RAW)
    _ACCEL_Z=$(twocp $_ACCEL_Z_RAW)

    _ABS_ACCEL_X=$(abs $_ACCEL_X)
    _ABS_ACCEL_Y=$(abs $_ACCEL_Y)
    _ABS_ACCEL_Z=$(abs $_ACCEL_Z)

    # orientation logic
    if [[ $_ABS_ACCEL_Z -gt $((_ABS_ACCEL_X * 4)) && $_ABS_ACCEL_Z -gt $((_ABS_ACCEL_Y * 4)) ]]; then
        _ORIENT="flat"
    elif [[ $((_ABS_ACCEL_Y * 3)) -gt $((_ABS_ACCEL_X * 2)) ]]; then
        _ORIENT=$([[ $_ACCEL_Y -gt 0 ]] && echo "inverted" || echo "normal")
    else
        _ORIENT=$([[ $_ACCEL_X -gt 0 ]] && echo "left" || echo "right")
    fi

    # rotate screen, remap touchscreen
    [[ "$_ORIENT" == "flat" ]] || [[ "$_ORIENT" == "$_LAST" ]] ||
        { xrandr --output $_DISPLAY --rotate $_ORIENT &&
            herbstclient detect_monitors &&
            xinput map-to-output $_INPUTID $_DISPLAY; }

    _LAST=$_ORIENT
done
