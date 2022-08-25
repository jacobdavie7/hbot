#!/bin/bash

function updater ()
{

    sudo apt update
    sudo apt upgrade
    sudo apt autoremove

    flatpak update

#    echo -e "\n\e[44mExecuting 'Updater' Function\e[49m"
#        #apt
#        echo -e "\n\e[95;4mapt\e[39;24m"
#            sudo apt update
#            UPGRADES=$(apt list --upgradeable | wc -l)
#            if [ "$UPGRADES" != "1" ]; then
#                echo -e "\n\e[4mApt Packages that can be Upgraded:\e[39;24m"
#                    apt list --upgradeable
#                echo -e "\n\e[4mRun Apt Upgradeable and Autoremove? (y or n)\e[39;24m"
#                    read ANS
#                    if [ "$ANS" == "y" ]; then
#                        sudo apt upgrade -y
#                        sudo apt autoremove -y
#                    fi
#            fi
#
#        #flatpak
#        echo -e "\n\e[95;4mflatpak\e[39;24m"
#            flatpak update
#
#        #snap
#        echo -e "\n\e[95;4msnap\e[39;24m"
#            sudo snap refresh
}