#!/bin/bash

function xfceFix
{
    #restart panel
        xfce4-panel -r

    #pulse
    #BREAKS OUTPUT, WILL NOT SHOW ANY DEVICES
        #systemctl --user restart pulseaudio.service
        #sleep 3
        #systemctl --user restart pulseaudio.socket
        
        #pacmd unload-module module-udev-detect
        #pacmd load-module module-udev-detect
        #pactl load-module module-detect

    #network manger
}