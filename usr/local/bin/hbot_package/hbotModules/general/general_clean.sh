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
    
    echo -e "\nRepair flatpak [remove invalid objects, not referenced, etc]"
        flatpak repair

    echo -e "\nRemoving disabled snaps"
        snap list --all | awk '/disabled/{print $1, $3}' |
        while read snapname revision; do
            snap remove "$snapname" --revision="$revision"
        done

    echo -e "\nEmpyting notification log"
        rm -r /home/$USER_ACCOUNT/.cache/xfce4/notifyd/*

    echo -e "\nVacuuming journalctl logs over 2 weeks"
        journalctl --vacuum-time=2w

    echo -e "\nVacuuming journalctl logs over 1G"
        journalctl --vacuum-size=1G
    
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