#!/bin/bash

function usage()
{
    echo -e "\n   Usage: helper [OPTION] [ARGUMENT]"
    echo -e "\n       Popular"
    echo -e "           -u  updater     Updates from apt, flatpak, and snap"
    echo -e "\n       Config"
    echo -e "           -d  drawing     Setup drawing tablet"
    echo -e "           -m  monitors    Setup displaylink and arrange monitors"
    echo -e "\n       Firewalls"
    echo -e "           -f  firewall    Deploy firewall rules - REQUIRES ARGUMENT"
    echo -e "                   web     Firewall ruleset for web server use"
    echo -e "                   backup  Firewall ruleset for backup server use"
    echo -e "                   home    Firewall ruleset for home use"
    echo -e "                   lax     Firewall ruleset for more lax home use - Allow all Out"
    echo -e "                   limited Firewall ruleset for more limited home use - Internet Only"
    echo -e "                   local   Firewall ruleset for 1337 hax - No Internet"
    echo -e "                   reset   FLUSH ALL rules and ACCEPT by default !!DANGER!!\n"
    echo -e "           -w  watcher     Watch firewall rule hits in packets and bytes"
    echo -e "\n       Special"
    echo -e "           -s  startup     good modules to run on startup"
    echo -e "           -i  install     Overall Machine Setup"
}