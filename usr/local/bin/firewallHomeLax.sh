#!/bin/bash

function firewallHomeLax
{
    echo -e "\n\e[44mDeploying Lax Home Firewall Rules\e[49m"

        echo -e "\nSetting default INPUT and FORWARD policy to DROP"
            sudo -i iptables -P INPUT DROP
            sudo -i iptables -P FORWARD DROP
            
        echo -e "Setting default OUTPUT policy to ALLOW"
            sudo -i iptables -P OUTPUT ACCEPT

        echo -e "\nFlushing all chains"
            sudo -i iptables -F

        echo -e "\nALLOW anything marked RELATED/ESTABLISHED"
            sudo -i iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT incoming RELATED/ESTABLISHED"
            sudo -i iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT outgoing RELATED/ESTABLISHED"
    
        echo "ALLOW everything on loopback"
            sudo -i iptables -A INPUT -s 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all incoming on loopback"
            sudo -i iptables -A OUTPUT -d 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all outgoing on loopback"

    echo -e "\n\e[31mDon't Forget About Edge Firewall!\e[39m\n"
}