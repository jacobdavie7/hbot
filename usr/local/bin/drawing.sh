#!/bin/bash

function drawing ()
{
    echo -e "\n\e[44mExecuting 'Drawing' Function\e[49m"

    #Append 70-wacom.conf
        XORG_APPEND=$(cat /usr/share/X11/xorg.conf.d/70-wacom.conf | grep "S620" | cut -d' ' -f2,3 | sed 's/ //g')
            if [ "$XORG_APPEND" != "GaomonS620" ]; then
                sudo chmod 664 /usr/share/X11/xorg.conf.d/70-wacom.conf
                echo -e '\n\n# Gaomon S620\nSection "InputClass"\n\tIdentifier "GAOMON Gaomon Tablet"\n\tMatchUSBID  "256c:006d"\n\tMatchDevicePath "/dev/input/event*"\n\tDriver "wacom"\nEndSection' >> /usr/share/X11/xorg.conf.d/70-wacom.conf
                sudo chmod 644 /usr/share/X11/xorg.conf.d/70-wacom.conf
                echo -e "Need to Restart/Logout Before Continuing. Do so and Run Script Again"
                exit
            else
                echo -e "\nEntry in config found!"
            fi

	#Find Input ID's (used to map to single display)
		INPUT_ID_PEN=$(xsetwacom --list | grep "GAOMON Gaomon Tablet Pen stylus"| cut -f2 | cut -d' ' -f2)
		INPUT_ID_PAD=$(xsetwacom --list | grep "GAOMON Gaomon Tablet Pad pad"| cut -f2 | cut -d' ' -f2)

    echo -e "\nMapping to display"
        echo " - Pen"
		    xinput map-to-output $INPUT_ID_PEN HDMI-0
		echo " - Pad"
            xinput map-to-output $INPUT_ID_PAD HDMI-0

	echo -e "\nMapping pad keys"
        echo " - pen"
            xsetwacom --set 'GAOMON Gaomon Tablet Pad pad' Button 1 key "+ctrl +shift p -shift -ctrl"	#Pen
        echo " - highlighter"
            xsetwacom --set 'GAOMON Gaomon Tablet Pad pad' Button 2 key "+ctrl +shift h -shift -ctrl"	#Highlighter
        echo " - undo"
            xsetwacom --set 'GAOMON Gaomon Tablet Pad pad' Button 3 key "+ctrl z -ctrl"			        #Undo
        echo " - redo"    
            xsetwacom --set 'GAOMON Gaomon Tablet Pad pad' Button 8 key "+ctrl y -ctrl"			        #Redo	#Yes, Button 8 is correct

    #Pen - Settings these will mess with program defualt hand + eraser behaviour
        # xsetwacom --set 'GAOMON Gaomon Tablet Pen stylus' Button 1 "KEYBINDINGHERE"   #Pen Tip
        # xsetwacom --set 'GAOMON Gaomon Tablet Pen stylus' Button 2 "KEYBINDINGHERE"   #Lower Button
        # xsetwacom --set 'GAOMON Gaomon Tablet Pen stylus' Button 2 "KEYBINDINGHERE"   #Upper Button
}