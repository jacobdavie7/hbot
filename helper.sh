#!/bin/bash

function updater
{
    echo -e "Executing 'Updater' Function"
    
    echo -e "\n\e[35mapt\e[39m"
    sudo apt update


    echo -e "\n\e[35mflatpak\e[39m"
    flatpak update

    echo -e "\n\e[35msnap\e[39m"
    sudo snap refresh
}

function monitors
{
    echo -e "Executing 'Monitors' Function"
    # Run xrandr --listproviders to view monitor outputs. Provider 0 should be GPU, 1-4 should be the adapters.
    # Should look like something below:
    # Provider 1: id: 0x138 cap: 0x2, Sink Output crtcs: 1 outputs: 1 associated providers: 0 name:modesetting
    # ...Goes to provider 4, looks like provider 1                                          ^ This 0 should change to 1 after the commands below

    xrandr --setprovideroutputsource 1 0
    xrandr --setprovideroutputsource 2 0
    xrandr --setprovideroutputsource 3 0
    xrandr --setprovideroutputsource 4 0

    # run xrandr to view names of adapters (DVI-I-1-1, and DP-0)
    xrandr --output HDMI-0 --primary --auto            #center monitor (primary)
    xrandr --output DP-1 --above HDMI-0 --auto         #top monitor
    xrandr --output DP-0 --left-of HDMI-0 --auto       #left monitor
    xrandr --output DVI-D-0 --right-of HDMI-0 --auto   #right monitor

    # https://github.com/AdnanHodzic/displaylink-debian/blob/master/post-install-guide.md
}

function drawing
{
    echo -e "Executing 'Drawing' Function"
    #Append 70-wacom.conf
        XORG_APPEND=$(cat /usr/share/X11/xorg.conf.d/70-wacom.conf | grep "S620" | cut -d' ' -f2,3 | sed 's/ //g')
        if [ "$XORG_APPEND" != "GaomonS620" ]; then
                sudo -i #spawn root sub-shell. This needs to be on its own line. Can't just use sudo, else the redirect does not get run as root.
                echo -e '\n\n# Gaomon S620\nSection "InputClass"\n\tIdentifier "GAOMON Gaomon Tablet"\n\tMatchUSBID  "256c:006d"\n\tMatchDevicePath "/dev/input/event*"\n\tDriver "wacom"\nEndSection' >> /usr/share/X11/xorg.conf.d/70-wacom.conf
                exit #exit root sub-shell
        fi
        # USBID can be found with 'lsusb'

	#Find Input ID's (used to map to single display)
		INPUT_ID_PEN=$(xsetwacom --list | grep "GAOMON Gaomon Tablet Pen stylus"| cut -f2 | cut -d' ' -f2)
		INPUT_ID_PAD=$(xsetwacom --list | grep "GAOMON Gaomon Tablet Pad pad"| cut -f2 | cut -d' ' -f2)

	#Map Wacom Input to Single Primary Display
		xinput map-to-output $INPUT_ID_PEN HDMI-0
		xinput map-to-output $INPUT_ID_PAD HDMI-0

	#Key Mapping
		xsetwacom --set 'GAOMON Gaomon Tablet Pad pad' Button 1 key "+ctrl +shift p -shift -ctrl"	#Pen
		xsetwacom --set 'GAOMON Gaomon Tablet Pad pad' Button 2 key "+ctrl +shift h -shift -ctrl"	#Highlighter
		xsetwacom --set 'GAOMON Gaomon Tablet Pad pad' Button 3 key "+ctrl z -ctrl"			        #Undo
		xsetwacom --set 'GAOMON Gaomon Tablet Pad pad' Button 8 key "+ctrl y -ctrl"			        #Redo	#Yes, Button 8 is correct

        #Pen - Settings these will mess with program defualt hand + eraser behaviour
        #   xsetwacom --set 'GAOMON Gaomon Tablet Pen stylus' Button 1 "KEYBINDINGHERE"   #Pen Tip
        #   xsetwacom --set 'GAOMON Gaomon Tablet Pen stylus' Button 2 "KEYBINDINGHERE"   #Lower Button
        #   xsetwacom --set 'GAOMON Gaomon Tablet Pen stylus' Button 2 "KEYBINDINGHERE"   #Upper Button
}

while getopts "umdt" FLAG; do
    case "$FLAG" in
        u)
            updater
            ;;
        m)
            monitors
            ;;
        d)
            drawing
            ;;
        *)
            echo -e "Usage: updater [OPTION]"
            echo -e "\t-u\tupdater\t\tUpdate from Multiple Package Managers"
            echo -e "\t-m\tmonitors\tSetup display link adapter and arrange monitors"
            echo -e "\t-d\tdrawing\t\tSetup drawing tablet"
            ;;
    esac
done