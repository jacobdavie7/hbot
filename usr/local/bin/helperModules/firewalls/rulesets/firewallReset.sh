#!/bin/bash

function firewallReset
{
    echo -e "\n\e[91mReseting all Firewall Rules (Default Accept + Flush Chains)\e[39m"
        echo -e "Setting default policy to ALLOW"
            iptables -P INPUT ACCEPT
            iptables -P OUTPUT ACCEPT
            iptables -P FORWARD ACCEPT

        echo -e "Flushing all chains"
            iptables -F

    firewallPersistentSave

    echo -e "\n\e[31mDon't Forget About Edge Firewall!\e[39m\n"
}