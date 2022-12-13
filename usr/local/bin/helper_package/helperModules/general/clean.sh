#!/bin/bash

function clean
{
    echo -e "\napt autoremove (dependencies)"
        apt autoremove -y
    
    echo -e "\napt clean (cache)"
        apt clean
    
    echo -e "\nflatpak (runtimes)"
        flatpak uninstall --unused -y

    echo -e "\nGUI Trash"
        rm -r /home/jacob/.local/share/Trash/*

    echo -e "\nthumbnails"
        rm -r /home/jacob/.cache/thumbnails/*

    echo -e "\ntmp"
        rm -r /tmp/*

    echo -e "\njournalctl logs"
        journalctl --vacuum-time=3d
}