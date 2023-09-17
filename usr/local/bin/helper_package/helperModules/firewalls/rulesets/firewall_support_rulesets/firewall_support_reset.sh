#!/bin/bash

function firewall_support_reset
{
    echo -e "\n\e[91mReseting all Firewall Rules (Default Accept + Flush Chains)\e[39m"
    echo -e "\nSetting default policy to ALLOW"
        iptables -P OUTPUT ACCEPT
        ip6tables -P OUTPUT ACCEPT

        iptables -P INPUT ACCEPT
        ip6tables -P INPUT ACCEPT

        iptables -P FORWARD ACCEPT
        ip6tables -P FORWARD ACCEPT

    echo -e "\nFlushing all chains"
        iptables -F
        ip6tables -F

    firewall_persistentSave

    echo -e "\n\e[31mDon't Forget About Edge Firewall!\e[39m\n"
}