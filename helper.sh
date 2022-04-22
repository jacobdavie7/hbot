#!/bin/bash

function updater
{
    echo -e "Executing 'Updater' Function"
    # apt
        echo -e "\n\e[35mapt\e[39m"
        sudo apt update
        echo
        apt list --upgradeable

        echo -e "\n\e[95mRun Apt Upgradeable? (y or n)\e[39m"
        read ANS
        if [ "$ANS" == "y" ]; then
            sudo apt upgrade -y

            echo -e "\n\e[95mRun Apt autoremove? (y or n)\e[39m"
            read ANS
            if [ "$ANS" == "y" ]; then
                sudo apt autoremove -y
            fi
        fi
    # flatpak
        echo -e "\n\e[35mflatpak\e[39m"
        flatpak update

    # snap
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

    # Enable DisplayLink Adapter
        xrandr --setprovideroutputsource 1 0
        xrandr --setprovideroutputsource 2 0
        xrandr --setprovideroutputsource 3 0
        xrandr --setprovideroutputsource 4 0

    #run xrandr to view adapter names (DVI-I-1-1, DP-0)                    Can't use both pos and left/right/above. Will mess with unlined top monitor
    
    #Center Monitor (Primary)                                       #Need to use pos to correctly line up top monitor. If only use --pos for top monitor, all the monitors will be on the same x level. 
        xrandr --output HDMI-0 --primary --pos 1440x1080 --auto     #                   --pos 1440x1080
    #Left Monitor
        xrandr --output DP-0 --pos 0x1080 --auto                    #--left-of HDMI-0   --pos 0x1080
    #Right Monitor
        xrandr --output DVI-D-0 --pos 3120x1080 --auto              #--right-of HDMI-0  --pos 3120x1080
    #Top Monitor
        xrandr --output DVI-I-1-1 --pos 1320x0 --auto               #--above HDMI-0     --pos 1320x0


    # https://github.com/AdnanHodzic/displaylink-debian/blob/master/post-install-guide.md
}

function drawing
{
    echo -e "Executing 'Drawing' Function"
    #Append 70-wacom.conf
        XORG_APPEND=$(cat /usr/share/X11/xorg.conf.d/70-wacom.conf | grep "S620" | cut -d' ' -f2,3 | sed 's/ //g')
        if [ "$XORG_APPEND" != "GaomonS620" ]; then
            echo -e "Use root Password as Using 'su'\n"
            su -c 'echo -e "\n\n# Gaomon S620\nSection \"InputClass\"\n\tIdentifier \"GAOMON Gaomon Tablet\"\n\tMatchUSBID  \"256c:006d\"\n\tMatchDevicePath \"/dev/input/event*\"\n\tDriver \"wacom\"\nEndSection\" >> /usr/share/X11/xorg.conf.d/70-wacom.conf' root
            echo -e "Need to Restart/Logout Before Continuing. Do so and Run Script Again"
            exit 0
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

function setup
{
    echo -e "Run full setup script? (yes or n)"
    read ANS
    if [ "$ANS" == "yes" ]; then
        echo -e "\nstuff"
        #updates
        #sudo group
        #apt installation
        #graphics
        #appearance
        #dns
        #firewall
    fi
}

HELP=1
while getopts "umdts" FLAG; do
    case "$FLAG" in
        u)
            HELP=0
            updater
            ;;
        m)
            HELP=0
            monitors
            ;;
        d)
            HELP=0
            drawing
            ;;
        s)
            HELP=0
            setup
            ;;
        *)
       #     echo -e "Usage: updater [OPTION]"
       #     echo -e "\t-u\tupdater\t\tUpdate from Multiple Package Managers"
       #     echo -e "\t-m\tmonitors\tSetup display link adapter and arrange monitors"
       #     echo -e "\t-d\tdrawing\t\tSetup drawing tablet"
       #     ;;
    esac
done

if [ $HELP -ne 0 ]; then
    echo -e "Usage: updater [OPTION]"
    echo -e "\t-u\tupdater\t\tUpdate from Multiple Package Managers"
    echo -e "\t-m\tmonitors\tSetup display link adapter and arrange monitors"
    echo -e "\t-d\tdrawing\t\tSetup drawing tablet"
    echo -e "\t-s\tsetup\t\tOverall Machine Setup"
fi