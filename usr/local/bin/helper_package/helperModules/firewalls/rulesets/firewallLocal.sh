#!/bin/bash

function firewallLocal
{
    echo -e "\n\e[44mDeploying Local Firewall Rules\e[49m"

    echo -e "\nSetting default policy to DROP"
        iptables -P OUTPUT DROP
        iptables -P INPUT DROP
        iptables -P FORWARD DROP

    echo -e "\nFlushing all chains"
        iptables -F
 
    echo -e "\nALLOW everything marked RELATED/ESTABLISHED"
        iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT incoming RELATED/ESTABLISHED"
        iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT outgoing RELATED/ESTABLISHED"

    echo "ALLOW everything on loopback"
        iptables -A INPUT -s 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all incoming on loopback"
        iptables -A OUTPUT -d 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all outgoing on loopback"

    echo " - Allow Private IP's (All Ports TCP and UDP)"
        echo " - Class C"
            iptables -A OUTPUT -d 192.168.0.0/16 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new to Private Class C"
        echo " - Class B"
            iptables -A OUTPUT -d 172.16.0.0/12 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new to Private Class B"
        echo " - Class A"
            iptables -A OUTPUT -d 10.0.0.0/8 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new to Private Class A"
        echo " - Localhost"
            iptables -A OUTPUT -d 127.0.0.1 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new to Loopback"            

    echo -e "\n\e[91mFirewall Ruleset Updated - NOT Persistant - Will be Cleared on Restart\e[39m"

    firewallv6Basic
}