#!/usr/bin/env bash

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}

monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi

# geometry has the format X Y W H
x=${geometry[0]}
y=${geometry[1]}
width=${geometry[2]}
height=16

font="-misc-termsyn-medium-*-normal-*-14-*-*-*-*-*-iso8859-1"
# bgcolor=$(hc get frame_border_normal_color)
# hlcolor=$(hc get window_border_active_color)

hc pad $monitor $height

uniq_linebuffered() {
    awk '$0 != l { print; l=$0; fflush(); }' "$@"
}

battery() {
    capacity=$(cat /sys/class/power_supply/BAT1/capacity)
    cat /sys/class/power_supply/BAT1/status | grep -q Charging &&
        echo -n "%{F#99cc99}+" || {
        [[ $capacity -lt 16 ]] && echo -n "%{B#f2777a}" || echo -n "%{F#ffcc66}"
    }
    echo -n $capacity
}

volume() {
    echo -n "%{F#f2777a}"
    soundstat=$(amixer get Master | tail -1)
    echo "$soundstat" | grep -q off && echo -n "-" ||
        echo "$soundstat" | cut -d ' ' -f 5
}

{
    ### Event generator ###
    # based on different input data (mpc, date, hlwm hooks, ...) this generates
    # events, formed like this:
    #   <eventname>\t<data> [...]
    # e.g.
    #   date    ^fg(#f2f0ec)18:33^fg(#909090), 2013-10-^fg(#f2f0ec)29

    # mpc idleloop player &
    # mpcpid=$!
    while true; do
        # "date" output is checked once every four seconds, but an event is
        # generated only if the output changed compared to the previous run.
        date +'date %{F#9999cc}%H:%M %{F#bbbbdd}%Y-%m-%{F#9999cc}%d'
        sleep 4 || break
    done > >(uniq_linebuffered) &
    datepid=$!

    hc --idle

    kill $datepid
} 2> /dev/null | {
    read -ra tags <<< "$(hc tag_status $monitor)"

    windowtitle=""
    date=""

    while true; do
        ### Output ###
        # This part prints lemonbar data based on the _previous_ data handling
        # run, and then waits for the next event to happen.

        separator="%{B-}%{F#ffcc66} | %{F-}"
        # draw tags
        echo -n "%{l}"
        for i in "${tags[@]}" ; do
            case ${i:0:1} in
                '#')
                    echo -n "%{B#ffcc66}%{F#2d2d2d}"
                    ;;
                '+')
                    echo -n "%{B#99cc99}%{F#2d2d2d}"
                    ;;
                ':')
                    echo -n "%{B-}%{F#f2f0ec}"
                    ;;
                '!')
                    echo -n "%{B#f2777a}%{F#2d2d2d}"
                    ;;
                *)
                    echo -n "%{B-}%{F#f2f0ec}"
                    ;;
            esac
            echo -n "%{A:herbstclient use_index:} ${i:1} %{A}"
        done
        echo -n "$separator"
        echo -n "${windowtitle//^/^^}"

        echo -n "%{r}"
        echo -n "$separator"
        echo -n "$(volume)"
        echo -n "$separator"
        echo -n "$(battery)%%"
        echo -n "$separator"
        echo -n "$date"
        echo -n "$separator"
        echo

        ### Data handling ###
        # This part handles the events generated in the event loop, and sets
        # internal variables based on them. The event and its arguments are
        # read into the array cmd, then action is taken depending on the event
        # name.
        # "Special" events (quit_panel/reload) are also handled here.

        # wait for next event
        read -ra cmd || break
        # find out event origin
        case "${cmd[0]}" in
            tag*)
                read -ra tags <<< "$(hc tag_status $monitor)"
                ;;
            date)
                date="${cmd[@]:1}"
                ;;
            quit_panel)
                exit
                ;;
            reload)
                exit
                ;;
            focus_changed|window_title_changed)
                windowtitle="${cmd[@]:2}"
                ;;
            # player)
            #     ;;
        esac
    done
} 2> /dev/null | lemonbar -g "$(printf '%dx%d%+d%+d' $width $height $x $y)" \
    -B '#31453b' -F '#f2f0ec' -f "$font"
