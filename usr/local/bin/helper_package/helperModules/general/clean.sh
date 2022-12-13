#!/bin/bash

function clean
{
    echo -e "\nRemoving unused apt dependencies (autoremove)"
        apt autoremove -y
    
    echo -e "\nRemoving apt cache (clean)"
        apt clean
    
    echo -e "\nRemoving unused flatpak runtimes"
        flatpak uninstall --unused -y

    echo -e "\nEmptying GUI trashcan"
        rm -r /home/jacob/.local/share/Trash/*

    echo -e "\nRemoving GUI thumbnails"
        rm -r /home/jacob/.cache/thumbnails/*

    echo -e "\nEmptying tmp"
        rm -r /tmp/*

    echo -e "\nVacuuming journalctl logs over 3 days"
        journalctl --vacuum-time=3d
}