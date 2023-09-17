#!/bin/bash

function firewall_home_lax
{
    firewall_v6_support_basic
    
    echo -e "\n\e[44mDeploying Lax Home Firewall Rules\e[49m"

        echo -e "\nSetting default INPUT and FORWARD policy to DROP"
            iptables -P INPUT DROP
            iptables -P FORWARD DROP
            
        echo -e "Setting default OUTPUT policy to ACCEPT"
            iptables -P OUTPUT ACCEPT

        echo -e "\nFlushing all chains"
            iptables -F

        echo -e "\nACCEPT everything marked RELATED/ESTABLISHED"
            iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT incoming RELATED/ESTABLISHED"
            iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT outgoing RELATED/ESTABLISHED"
    
        echo "ACCEPT everything on loopback"
            iptables -A INPUT -s 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all incoming on loopback"
            iptables -A OUTPUT -d 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all outgoing on loopback"

    firewall_persistentSave
}