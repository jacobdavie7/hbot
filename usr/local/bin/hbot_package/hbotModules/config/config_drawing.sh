#!/bin/bash

function config_drawing
{
    echo -e "\n\e[44mExecuting 'Drawing' Function\e[49m"
    # https://github.com/bigbigmdm/GAOMON-S620-in-LINUX

    # need x11 config updated once. This is persitent after restart. Moved to install module so this can be run without root
            XORG_APPEND=$(cat /usr/share/X11/xorg.conf.d/70-wacom.conf | grep "S620" | cut -d' ' -f2,3 | sed 's/ //g')
            if [ "$XORG_APPEND" != "GaomonS620" ]; then
                echo -e "\nNo Config Entry found, assuming 1st time setup.\n"

                # the initial setup stuff requires root
                    support_elevateCheck    # verify root, don't check this when module initially called, want to run rest of module without sudo. This portion only needs to be run once and is persitent 
                
                # install xinput, needed for mapping
                    echo " - installing xinput"
                    echo -e "\nNo Config Entry found, assuming 1st time setup.\n"
                    apt install xinput -y

                # edit the config file
                echo " - editing config file"
                chmod 664 /usr/share/X11/xorg.conf.d/70-wacom.conf
                echo -e '\n\n# Gaomon S620\nSection "InputClass"\n\tIdentifier "GAOMON Gaomon Tablet"\n\tMatchUSBID  "256c:006d"\n\tMatchDevicePath "/dev/input/event*"\n\tDriver "wacom"\nEndSection' >> /usr/share/X11/xorg.conf.d/70-wacom.conf
                chmod 644 /usr/share/X11/xorg.conf.d/70-wacom.conf
                
                echo "\n\nSet the following preferances within xournalpp (Edit > Preferances)"
                echo " - Input System Tab"
                echo "    - Set GAOMON Gaemon Tablet Pad pad (tablet pad) > Mouse + Keyboard Combo (This will allow button on tablet to be keyboard input)"
                echo "    - Set Both keyboard inputs (noted as mouse) > Mouse + Keyboard Combo (This will allow keyboard to enter text input)"
                echo "    - Set GAOMON Gaemon Tablet Pad pad (tablet pad) > Mouse + Keyboard Combo (This will allow button on tablet to be keyboard input)"
                echo " - Stylus Tab"
                echo "    - Set button 1 to Eraser"
                echo "    - Set button 2 to Hand"
                echo "\n - Toolbar (not from preferances menu)> View > Toolbars > Xournal++"
                echo -e "\nNeed to Restart/Logout Before Continuing. Do so and RUN SCRIPT AGAIN"
                exit
            else
                echo -e "\nEntry in config found!"
            fi
        
	#Find Input ID's (used to map to single display)
		INPUT_ID_PEN=$(xsetwacom --list | grep "GAOMON Gaomon Tablet Pen stylus"| cut -f2 | cut -d' ' -f2)
		INPUT_ID_PAD=$(xsetwacom --list | grep "GAOMON Gaomon Tablet Pad pad"| cut -f2 | cut -d' ' -f2)

    echo -e "\nMapping to display"
        echo " - Pen"
		    xinput map-to-output $INPUT_ID_PEN DP-0
		echo " - Pad"
            xinput map-to-output $INPUT_ID_PAD DP-0

	echo -e "\nMapping pad keys"
        echo " - pen"
            xsetwacom --set 'GAOMON Gaomon Tablet Pad pad' Button 1 key "+ctrl +shift p d -shift -ctrl"	#Pen, p to select pen, d to deselect (d stands for default) shapes that are drawn with pen and take priority over freedraw
        echo " - highlighter"
            xsetwacom --set 'GAOMON Gaomon Tablet Pad pad' Button 2 key "+ctrl +shift h -shift -ctrl"	#Highlighter
        echo " - undo"
            xsetwacom --set 'GAOMON Gaomon Tablet Pad pad' Button 3 key "+ctrl z -ctrl"			        #Undo
        echo " - redo"    
            xsetwacom --set 'GAOMON Gaomon Tablet Pad pad' Button 8 key "+ctrl y -ctrl"			        #Redo	#Yes, Button 8 is correct

    #Pen - Settings these will mess with program defualt hand + eraser behaviour. Set the button functions in xournalpp, instead of using keyboard shortcuts because if the buttons send a keystroke, the tool will change. Setting in software will only have the tool selected when held down
        # xsetwacom --set 'GAOMON Gaomon Tablet Pen stylus' Button 1 "KEYBINDINGHERE"   #Pen Tip
        # xsetwacom --set 'GAOMON Gaomon Tablet Pen stylus' Button 2 "KEYBINDINGHERE"   #Lower Button
        # xsetwacom --set 'GAOMON Gaomon Tablet Pen stylus' Button 2 "KEYBINDINGHERE"   #Upper Button
}