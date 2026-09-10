#!/bin/sh

debug=0
dry_run=0

print_help(){
    echo "Usage: $0 [--debug] [--dry-run] <action>"
}

while [ $# -gt 0 ]; do
    case "$1" in
        --debug)
            debug=1
            shift
            ;;
        --dry-run)
            dry_run=1
            shift
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        -*)
            echo "Unknown option: $1" >&2
            print_help
            exit 1
            ;;
          *)
            action="$1"
            shift
            ;;

    esac
done

[ "$debug" -gt 0 ] && echo "Debug mode on"
[ "$dry_run" -gt 0 ] && [ "$debug" -gt 0 ] && echo "Dry run mode on"

if [ -z "$action" ]; then 
    echo "No action specified!"
    print_help
    exit 1
fi


[ "$debug" -gt 0 ] && echo "Action: $action"

builtin_display="eDP-1"

# jq explanation: Get an array of all the outputs that are not "eDP-1" (built-in display) and get the length
num_outputs=$(swaymsg -t get_outputs -r | jq --arg BUILTIN "$builtin_display" '[.[] | select(.name != $BUILTIN)] | length')
[ "$debug" -gt 0 ] && echo "Num external outputs: $num_outputs"

if [ "$dry_run" -gt 0 ]; then
    echo "Would have tried to $action $builtin_display"
    exit
fi
if [ "$action" = "disable" ]; then
    if [ "$num_outputs" -gt 0 ]; then
        swaymsg output "$builtin_display" disable
    fi
elif [ "$action" = "enable" ]; then
    swaymsg output "$builtin_display" enable
fi
