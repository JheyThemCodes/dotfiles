#!/bin/sh

WALL_DIR="${XDG_CONFIG_HOME}/wallpapers"

__stdout_list(){
    # Find all image files, print file in front for sorting, then trim it off
    find "$1" -regextype egrep -iregex ".*\.(jpg|jpeg|png|gif|webp)" -type f -printf "%f|%p\n" | sort | cut -d"|" -f 2
}

CURRENT_WALLPAPER="$( awww query -j | jq -r '.""[0].displaying.image' )"

__rofi_selector () {
    # grep input for the current wallpaper, use -n to get which number it is, cut to get just the number
    selected_row="$( __stdout_list "$1" | grep -m1 -n "$CURRENT_WALLPAPER" | cut -d ":" -f1 )"
    # Decrement row by 1 because grep is 1-indexed
    selected_row=$(($selected_row - 1))
    __stdout_list "$1" |
        while read imageFile; do
            echo -en "$imageFile\0display\x1f$(basename "$imageFile")\x1ficon\x1f$imageFile\n"
        done |
            rofi -show-icons -i -theme image-picker.rasi -dmenu -a "$selected_row" -selected-row "$selected_row"
}



SELECTOR="__rofi_selector"

if [ "$1" = "--random" ]; then
    entry=$( __stdout_list "$WALL_DIR" | shuf -n 1)
else
    entry=$( $SELECTOR "$WALL_DIR" )
fi
if [ -n "${entry}" ] ; then
    notify-send "Changing to $(basename "$entry")"
    theme="$(basename "$( dirname "$entry" )")"
    if [ -e "$( dirname "$entry" )/theme.json" ]; then
        theme="$( dirname "$entry" )/theme.json"
    fi
    light_dark="${theme##*-}"
    if [ "${light_dark}" = "light" ] || [ "${light_dark}" = "dark" ]; then
        theme="${theme%-*}"
    else
        light_dark=""
    fi
    if [ "${light_dark}" = "light" ]; then
        light_flag="-l"
    else
        light_flag=""
    fi
    awww img -t any "$entry"
    if [ "$theme" == "other" ]; then
        notify-send "Generating theme..."
        wal -n --cols16 foxify-darken -i "$entry" -o pywal-post.sh --contrast 1.5
    else
        notify-send "Using $theme"
        wal -n --cols16 foxify-darken $light_flag --theme "$theme" -o pywal-post.sh --contrast 1.5
    fi
else
    exit 1
fi

