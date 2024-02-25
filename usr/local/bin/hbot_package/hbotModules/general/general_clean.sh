#!/bin/bash

function general_clean
{
    echo -e "\nRemoving unused apt dependencies (autoremove)"
        apt autoremove -y
    
    echo -e "\nRemoving old apt cache (autoclean) [deletes packages from cache that are obsolte or have newer versions]"
        apt autoclean -y

    echo -e "\nRemoving entire apt cache (clean) [delete all packages from cache, more agressive than autoclean]"
        apt clean -y
    
    echo -e "\nRemoving unused flatpak runtimes"
        flatpak uninstall --unused -y
    
    echo -e "\nRemoving flatpak cache"
        rm -rf /var/tmp/flatpak-cache-*

    echo -e "\nEmpyting notification log"
        rm -r /home/$USER_ACCOUNT/.cache/xfce4/notifyd/*

    echo -e "\nVacuuming journalctl logs over 3 days"
        journalctl --vacuum-time=3d
    
    echo -e "\nEmptying tmp"
        rm -r /tmp/*

    echo -e "\nEmptying GUI trashcan"
        rm -r /home/$USER_ACCOUNT/.local/share/Trash/*

    echo -e "\nRemoving GUI thumbnails"
        rm -r /home/$USER_ACCOUNT/.cache/thumbnails/*

    echo -e "\n\e[4mEmpty Downloads for \e[91m$USER_ACCOUNT\e[39m (UID 1000)? (y or N)\e[24m"
        read ANS
        if [ "$ANS" == "y" ]; then
            echo -e "\nRemoving downloads for $USER_ACCOUNT\n"
            rm -r /home/$USER_ACCOUNT/Downloads/*
        fi
}