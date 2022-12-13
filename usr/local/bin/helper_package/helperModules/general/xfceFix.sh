#!/bin/bash

function xfceFix
{
    echo "currently broke. Does nothing"
    # restart panel
        #su jacob -c xfce4-panel -r

    # lightdm - will fix xfce if panel restart breaks everything
        #systemctl restart lightdm
   
    #pulse BREAKS OUTPUT, WILL NOT SHOW ANY DEVICES
        #systemctl --user restart pulseaudio.service
        #sleep 3
        #systemctl --user restart pulseaudio.socket
        
        #pacmd unload-module module-udev-detect
        #pacmd load-module module-udev-detect
        #pactl load-module module-detect

    #network manger
}