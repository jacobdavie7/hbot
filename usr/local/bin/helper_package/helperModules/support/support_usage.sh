#!/bin/bash

function support_usage
{
    echo -e "\n   Usage: helper [OPTION] [ARGUMENT]"
    echo -e "\n       General"
    echo -e "           -u  updater*     updates from apt, flatpak, and snap"
    echo -e "           -x  xfce fixer   basic xfce fixes for when it breaks"
    echo -e "           -c  clean*       delete stuff for bounus space! (apt, fp, trash, thumbnails, tmp, logs, downloads)" 
    echo -e "\n       Config"
    echo -e "           -d  drawing      setup drawing tablet"
    echo -e "           -m  monitors     setup displaylink and arrange monitors"
    echo -e "           -v  vpn*         setup Mullvad VPN, - REQUIRES ARGUMENT - Mullvad must be running LOCALLY"
    echo -e "                   home     standard vpn config + deploy home firewall ruleset"
    echo -e "                   mobile   home vpn config without local LAN access"
    echo -e "           -t  timezone*    temporarily change timezone - REQUIRES ARGUMENT"   
    echo -e "                   pacific  America/Los_Angeles"
    echo -e "                   mountain America/Denver"
    echo -e "                   central  America/Chicago"
    echo -e "                   eastern  America/New_York"
    echo -e "                   arizona  America/Phoenix"
    echo -e "                   korea    Asia/Seoul"
    echo -e "                   auto     GeoClue"
    echo -e "\n       Firewalls"
    echo -e "           -f  firewall*    deploy firewall ruleset - REQUIRES ARGUMENT"
    echo -e "                   home     standard home use"
    echo -e "                   lax      lax home use - Allow all Out"
    echo -e "                   lax_in   lax home use with inbound - Allow all Out, AND accept ssh and ping IN"
    echo -e "                   limited  limited home use - Internet Only (HTTP, HTTPS, DNS)"
    echo -e "                   secure   encrypted internt only (HTTPS, DoH, DoT) - HTTP and DNS over 53 will NOT work"
    echo -e "                   vm       limited home use - Internet Only (HTTP, HTTPS, DNS) WITHOUT local access"
    echo -e "                   local    no internet, use when doing 1337 hax"
    echo -e "                   web      web server use"
    echo -e "                   backup   backup server use"
    echo -e "                   wol      wake on lan server use"
    echo -e "                   reset    FLUSH ALL rules and ACCEPT by default !!DANGER!!"
    echo -e "           -w  watcher*     Watch firewall rule hits in packets and bytes"
    echo -e "\n       Special"
    echo -e "           -s  startup*     good modules to run on startup"
    echo -e "           -i  install*     overall Machine Setup"
}