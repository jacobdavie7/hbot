#!/bin/bash

function firewallReset
{
    echo -e "\n\e[91mReseting all Firewall Rules (Default Accept + Flush Chains)\e[39m"
        if [ "$EVEVATE" == "root" ]; then
            echo -e "Running as Root, commands will be run WITHOUT sudo"
            echo -e "Setting default policy to ALLOW"
                iptables -P INPUT ACCEPT
                iptables -P OUTPUT ACCEPT
                iptables -P FORWARD ACCEPT

            echo -e "Flushing all chains"
                iptables -F
        else
            echo -e "Running as standerd user, commands will be run with sudo"
            echo -e "Setting default policy to ALLOW"
                sudo -i iptables -P INPUT ACCEPT
                sudo -i iptables -P OUTPUT ACCEPT
                sudo -i iptables -P FORWARD ACCEPT

            echo -e "Flushing all chains"
                sudo -i iptables -F
        fi

    firewallPersistentSave

    echo -e "\n\e[31mDon't Forget About Edge Firewall!\e[39m\n"
}