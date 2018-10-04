#!/bin/bash

[[ $1 == "unload" ]] && _ARGS="-r"
_UPTIME=$(uptime -p | awk '{print $4}')
[[ ${_UPTIME} > "0" ]] && modprobe ${_ARGS} i2c_hid
