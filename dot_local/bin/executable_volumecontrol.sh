#!/bin/bash

get_default_sink(){
    local default_sink
    default_sink=$(wpctl inspect @DEFAULT_AUDIO_SINK@ | grep -oP 'node.description = "\K[^"]+' | head -1)
    if [ -z "$default_sink" ]; then
        default_sink=$(pw-dump | jq -r '[.[] | select(.info?.props?."media.class" == "Audio/Sink")] | min_by(.info.props."priority.session" // 9999) | .info.props."node.description"')
    fi
    echo "${default_sink}"
}

notify_sound(){
    mute="$(pamixer --get-mute)"
    if ${mute}; then
        title="Muted"
        vol=0
    else
        vol="$(pamixer --get-volume)"
        title="${vol}%"
    fi
    # -h "int:value:$vol" means makes this have a filled portion
    # -h string:x-canonical-private-synchronous:volume gives this an extra id "volume" and causes it to replace
    notify-send -t 1000 -a pw-volume -h string:x-canonical-private-synchronous:volume -h "int:value:$vol" "${title}" "${sink}"

}


sink=$(get_default_sink)
case "$1" in
    i | increase)
        echo "Increasing volume on ${sink}"
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        wpctl set-volume "@DEFAULT_AUDIO_SINK@" 5%+ 
        notify_sound
        ;;
    d | decrease)
        echo "Decreasing volume on ${sink}"
        wpctl set-volume "@DEFAULT_AUDIO_SINK@" 5%-
        notify_sound
        ;;
    m | mute)
        echo "Toggling Mute on ${sink}"
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle                                                                
        notify_sound
    ;;
    *)
    echo "Invalid input detected!"
    exit 1
    ;;
esac
