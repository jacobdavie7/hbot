#!/bin/bash

function firewall_persistentSave
{ 
    IP_PER=$(dpkg -l iptables-persistent | grep iptables-persistent | cut -d' ' -f3)
    if [ "$IP_PER" != "iptables-persistent" ]; then
        echo -e "\n\e[91mRuleset deployed, but iptables-persistent is NOT installed. Rules WILL be lost on restart.\e[39m"
        echo -e "\e[31mRun \e[4mapt install iptables-persistent\e[0m\e[31m to keep current ruleset after restart.\e[39m"
        echo -e "\e[31mUpon install, only the current ruleset will be saved. Changes to rules outside of the script will not be saved.\e[39m"
    else
        iptables-save > /etc/iptables/rules.v4
        ip6tables-save > /etc/iptables/rules.v6
        echo -e "\n\e[32miptables-persistent found! Ruleset saved and will be persistent on restart.\e[39m\n"
    fi
}