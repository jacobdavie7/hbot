#!/bin/bash

function updater ()
{
    echo -e "\n\e[44mExecuting 'Updater' Function\e[49m"
        #apt
        echo -e "\n\e[95;4mapt\e[39;24m"
            sudo apt update
            UPGRADES=$(apt list --upgradeable | wc -l)
            if [ "$UPGRADES" != "1" ]; then
                echo -e "\n\e[4mApt Packages that can be Upgraded:\e[39;24m"
                    apt list --upgradeable
                echo -e "\n\e[4mRun Apt Upgradeable? (y or n)\e[39;24m"
                    read ANS
                    if [ "$ANS" == "y" ]; then
                        sudo apt upgrade -y
                        echo -e "\n\e[4mRun Apt autoremove? (y or n)\e[39;24m"
                            read ANS
                            if [ "$ANS" == "y" ]; then
                                sudo apt autoremove -y
                            fi
                    fi
            fi

        #flatpak
        echo -e "\n\e[95;4mflatpak\e[39;24m"
            flatpak update

        #snap
        echo -e "\n\e[95;4msnap\e[39;24m"
            sudo snap refresh
}
