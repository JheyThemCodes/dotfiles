#!/usr/bin/env sh

notify_brightness(){
    brightness=$(brightnessctl info | grep -oP "(?<=\()\d+(?=%)" | cat)
    brightinfo=$(brightnessctl info | awk -F "'" '/Device/ {print $2}')
    title="${brightness}%"
    # -h "int:value:$brightness" means makes this have a filled portion
    # -h string:x-canonical-private-synchronous:brightness gives this an extra id "brightness" and causes it to replace
    notify-send -t 1000 -a brightness -h string:x-canonical-private-synchronous:brightness -h "int:value:$brightness" "${title}" "${brightinfo}"

}

case "$1" in
    i | increase)
        echo "Increasing brightness"
        brightnessctl set +10%
        ;;
    d | decrease)
        echo "Decreasing brightness"
        brightnessctl set 10%-
        ;;
    *)
    echo "Invalid input detected!"
    exit 1
    ;;
esac
notify_brightness