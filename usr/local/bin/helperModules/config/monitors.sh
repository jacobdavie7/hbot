#!/bin/bash

function monitors
{
    echo -e "\n\e[44mExecuting 'Monitors' Function\e[49m"
    
    echo -e "\nNvidia X Server: Force full composition pipeline"     #Helps with screen tearing. Must be run before setting outputs and locations
        nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"

    echo "Setting output"
    echo " - 1 to 0"
        xrandr --setprovideroutputsource 1 0
    echo " - 2 to 0"
        xrandr --setprovideroutputsource 2 0
    echo " - 3 to 0"
        xrandr --setprovideroutputsource 3 0
    echo " - 4 to 0"
        xrandr --setprovideroutputsource 4 0

    # run xrandr to view adapter names (DVI-I-1-1, DP-0)
    
    echo "Setting locations"
    echo " - Center (Pri)"                                       #Need to use pos to correctly line up top monitor. If only use --pos for top monitor, all the monitors will be on the same x level. 
        xrandr --output HDMI-0 --primary --pos 1440x1080 --auto     #                   --pos 1440x1080
    echo " - Left"
        xrandr --output DP-0 --pos 0x1080 --auto                    #--left-of HDMI-0   --pos 0x1080
    echo " - Right"
        xrandr --output DVI-D-0 --pos 3120x1080 --auto              #--right-of HDMI-0  --pos 3120x1080
    echo " - Top (TV)"
        xrandr --output DVI-I-1-1 --pos 1320x0 --auto               #--above HDMI-0     --pos 1320x0

    echo -e "\n\e[91mIf the top monitor is still NOT functioning and drivers ARE installed (from GitHub), the USB DisplayLink adapter may need to be reseated.\e[39m"
    
    # https://github.com/AdnanHodzic/displaylink-debian.git
    # https://github.com/AdnanHodzic/displaylink-debian/blob/master/post-install-guide.md
}