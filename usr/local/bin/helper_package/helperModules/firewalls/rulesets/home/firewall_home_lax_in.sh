#!/bin/bash

function firewall_home_lax_in
{
    firewall_v6_support_basic
    
    echo -e "\n\e[44mDeploying Lax IN Home Firewall Rules\e[49m"

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

        echo -e "\nACCEPT services IN"
            echo " - SSH        (ACCEPT - IN)"
                iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming ssh"
            echo " - PING       (ACCEPT - IN)"
                iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ping request"

    firewall_persistentSave
}