#!/bin/bash

function firewallReset
{
    echo -e "\n\e[91mReseting all Firewall Rules (Default Accept + Flush Chains)\e[39m"
    echo -e "\nSetting default policy to ALLOW"
        iptables -P OUTPUT ALLOW
        ip6tables -P OUTPUT ALLOW

        iptables -P INPUT ALLOW
        ip6tables -P INPUT ALLOW

        iptables -P FORWARD ALLOW
        ip6tables -P FORWARD ALLOW

    echo -e "\nFlushing all chains"
        iptables -F
        ip6tables -F

    firewallPersistentSave

    echo -e "\n\e[31mDon't Forget About Edge Firewall!\e[39m\n"
}