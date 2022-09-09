#!/bin/bash

function firewallLocal
{
    echo -e "\n\e[44mDeploying Local Firewall Rules\e[49m"

    echo -e "\nSetting default policy to DROP"
        sudo -i iptables -P OUTPUT DROP
        sudo -i iptables -P INPUT DROP
        sudo -i iptables -P FORWARD DROP

    echo -e "\nFlushing all chains"
        sudo -i iptables -F

    echo -e "\nDROP bad packets"
        echo " - XMAS       (IN)"
            sudo -i iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP -m comment --comment "DROP outgoing XMAS"
        echo " - INVALID    (IN)"
            sudo -i iptables -A INPUT -m conntrack --ctstate INVALID -j DROP -m comment --comment "DROP anything marked INVALID"
        echo " - Fragmented (IN)"
            sudo -i iptables -A INPUT -f -j DROP -m comment --comment "DROP Fragmented"
 
    echo -e "\nALLOW anything marked RELATED/ESTABLISHED"
        sudo -i iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT incoming RELATED/ESTABLISHED"
        sudo -i iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT outgoing RELATED/ESTABLISHED"

    echo " - Allow Private IP's (All Ports TCP and UDP)"
        echo " - Class C"
            sudo -i iptables -A OUTPUT -d 192.168.0.0/16 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new to Private Class C"
        echo " - Class B"
                sudo -i iptables -A OUTPUT -d 172.16.0.0/12 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new to Private Class B"
        echo " - Class A"
            sudo -i iptables -A OUTPUT -d 10.0.0.0/8 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new to Private Class A"
        echo " - Localhost"
            sudo -i iptables -A OUTPUT -d 127.0.0.1 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new to Loopback"            

    echo -e "\n\e[91mFirewall Ruleset Updated - NOT Persistant - Will be Cleared on Restart\e[39m"
}