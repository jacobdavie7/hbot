#! /bin/bash

function config_monitors_custom
{
    WIDTH=1875
    LENGTH=950
    REFRESH=60
    SCREEN_NAME=Virtual1
    # exact size of vm is 1920x983 (1010 without panel bar). Easy to find if go to seamless mode, then back to windowed mode and check size. 
    # perfered size of 1875x950. Gives a little bit of space to remind in vm
    # Sizes are also not exact, screen will often end of being a couple pixles more than specififed
    # for virtual box to do it automatically, ensure "auto-resize guest dispaly" is enabled

    # cvt calcutates info, tail -1 gives just the last line, sed removes the 1st word. This exact info will be later passed to xrandr as a new mode
        MODELINE=$(cvt $WIDTH $LENGTH $REFRESH | tail -1 | sed 's/^[^[:space:]]*[[:space:]]*//')

    # add the new mode to xrandr
        xrandr --newmode $MODELINE

    # copy MODELINE to SIZE
            FULL_SIZE=$MODELINE

    # just keep 1st word of SIZE (from MODELINE) for xrandr as an added mode (diffrent from new mode)
            FULL_SIZE=$(echo $FULL_SIZE | sed 's/^\([^[:space:]]*\).*$/\1/')

    # add new mode to list of modes the monitor can use
        xrandr --addmode $SCREEN_NAME $FULL_SIZE

    # drop double quotation marks and refresh rate after underscore from FULL_SIZE
        SIZE=$(echo $FULL_SIZE | sed 's/"\([^"_]*\)_.*/\1/')

    # set new screen size
        xrandr --size $SIZE
}