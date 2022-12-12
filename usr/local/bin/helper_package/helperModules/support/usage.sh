#!/bin/bash

function usage
{
    echo -e "\n   Usage: helper [OPTION] [ARGUMENT]"
    echo -e "\n       General"
    echo -e "           -u  updater     Updates from apt, flatpak, and snap"
    echo -e "           -x  xfce fixer  Basic xfce fixes for when it breaks"  
    echo -e "\n       Config"
    echo -e "           -d  drawing     Setup drawing tablet"
    echo -e "           -m  monitors    Setup displaylink and arrange monitors"
    echo -e "           -v  vpn         Setup Mullvad VPN"   
    echo -e "\n       Firewalls"
    echo -e "           -f  firewall    Deploy firewall ruleset - REQUIRES ARGUMENT"
    echo -e "                   web     web server use"
    echo -e "                   backup  backup server use"
    echo -e "                   home    standard home use"
    echo -e "                   lax     lax home use - Allow all Out"
    echo -e "                   limited limited home use - Internet Only (HTTP, HTTPS, DNS)"
    echo -e "                   secure  encrypted internt only (HTTPS, DoH, DoT) - HTTP and DNS will NOT work"
    echo -e "                   local   no internet, use when doing 1337 hax"
    echo -e "                   reset   FLUSH ALL rules and ACCEPT by default !!DANGER!!\n"
    echo -e "           -w  watcher     Watch firewall rule hits in packets and bytes"
    echo -e "\n       Special"
    echo -e "           -s  startup     good modules to run on startup"
    echo -e "           -i  install     Overall Machine Setup"
}