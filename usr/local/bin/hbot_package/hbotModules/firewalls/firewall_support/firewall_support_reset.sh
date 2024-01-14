#!/bin/bash

function firewall_support_reset
{
    echo -e "\n\e[91mReseting ALL Firewall Rules (including v4 AND v6) (Default Accept + Flush Chains)\e[39m"
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

    echo -e "\nDeleting added chains"
        iptables -X
        ip6tables -X

    echo -e "\n\e[31mDoes not call persistent save, WILL BE LOST ON RESTART\e[39m\n"
    echo -e "\n\e[31mDon't Forget About Edge Firewall!\e[39m\n"
}