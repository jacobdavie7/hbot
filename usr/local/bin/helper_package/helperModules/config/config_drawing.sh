#!/bin/bash

function config_drawing
{
    echo -e "\n\e[44mExecuting 'Drawing' Function\e[49m"

    # need x11 config updated once. This is persitent after restart. Moved to install module so this can be run without root

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