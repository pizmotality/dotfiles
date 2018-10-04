#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# scale built-in display
# _DISPLAY=$(xrandr | grep -m 1 " connected" | cut -d' ' -f1)
# xrandr --output $_DISPLAY --scale "0.5x0.5"

# set wallpaper
feh --bg-scale $HOME/.wallpaper.jpg

# enable autorotate
# $HOME/.linux-sp4/autorotate.sh &

# start herbstluftwm
exec herbstluftwm
