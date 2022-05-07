#!/bin/bash

function help()
{
    echo -e "\n   Usage: helper [OPTION] [ARGUMENT]"
    echo -e "\n       Popular"
    echo -e "           -u  updater     Updates from apt, flatpak, and snap"
    echo -e "\n       Config"
    echo -e "           -m  monitors    Setup displaylink and arrange monitors"
    echo -e "           -d  drawing     Setup drawing tablet"
    echo -e "\n       Firewalls"
    echo -e "           -f  firewall    Deploy firewall rules - REQUIRES ARGUMENT"
    echo -e "                   home    Firewall ruleset for home use"
    echo -e "                   web     Firewall ruleset for web server use"
    echo -e "                   backup  Firewall ruleset for backup server use"
    echo -e "                   reset   FLUSH ALL rules and ACCEPT by default !!DANGER!!\n"
    echo -e "           -w  watcher     Watch firewall rule hits in packets and bytes"
    echo -e "\n       Special"
    echo -e "           -s  startup     good modules to run on startup"
    echo -e "           -i  install     Overall Machine Setup"
}