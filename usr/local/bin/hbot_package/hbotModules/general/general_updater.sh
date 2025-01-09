#!/bin/bash

function general_updater
{
    echo -e "\n\e[44mUpdating Packages\e[49m"

    echo -e "\n\e[95;4mapt.\e[39;24m"
        echo -e "\n\e[96mupdate\e[39m"
            apt update
        echo -e "\n\e[96mupgrade\e[39m"
            apt upgrade -y
        echo -e "\n\e[96mautoremove\e[39m"
            apt autoremove -y
        
    echo -e "\n\e[95;4mpacman\e[39;24m"
        pacman -Syu
    
    echo -e "\n\e[95;4mflatpak\e[39;24m"
        echo -e "\n\e[96mupdate\e[39m"
            flatpak update -y
        echo -e "\n\e[96mautoremove\e[39m"
            flatpak uninstall --unused -y
        
    echo -e "\n\e[95;4msnap\e[39;24m"
        snap refresh
    
    echo -e "\n\e[95;4mnpm\e[39;24m"
        npm update -g
    
    echo -e "\n\e[95;4mhomebrew\e[39;24m"
        echo -e "\n\e[96mupdate\e[39m"
            brew update
        echo -e "\n\e[96mupgrade\e[39m"
            brew upgrade
}