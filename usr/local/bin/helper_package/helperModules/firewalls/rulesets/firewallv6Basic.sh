#!/bin/bash

function firewallv6Basic
{
    echo -e "\n\e[44mDeploying Base IPv6 Firewall Rules\e[49m"

        echo -e "\nSetting default policy to DROP"
            ip6tables -P OUTPUT DROP
            ip6tables -P INPUT DROP
            ip6tables -P FORWARD DROP

        echo -e "\nFlushing all IPv6 chains"
            ip6tables -F

        echo -e "\nALLOW anything marked RELATED/ESTABLISHED"
            ip6tables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT incoming RELATED/ESTABLISHED"
            ip6tables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT outgoing RELATED/ESTABLISHED"
    
        echo "ALLOW everything on loopback"
            ip6tables -A INPUT -i lo -j ACCEPT -m comment --comment "ACCEPT all incoming on loopback"
            ip6tables -A OUTPUT -o lo -j ACCEPT -m comment --comment "ACCEPT all outgoing on loopback"

    firewallPersistentSave
}