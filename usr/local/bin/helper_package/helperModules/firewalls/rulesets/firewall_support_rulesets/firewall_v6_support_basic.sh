#!/bin/bash

function firewall_v6_support_basic
{
    echo -e "\n\e[44mDeploying Base IPv6 Firewall Rules\e[49m"

        echo -e "\nSetting default policy to DROP"
            ip6tables -P OUTPUT DROP
            ip6tables -P INPUT DROP
            ip6tables -P FORWARD DROP

        echo -e "\nFlushing all IPv6 chains"
            ip6tables -F

        echo -e "\nDROP bad packets"
                echo " - XMAS       (DROP - IN)"
                    ip6tables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP -m comment --comment "DROP outgoing XMAS"
                echo " - NULL       (DROP - IN)"
                    ip6tables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP -m comment --comment "DROP outgoing NULL"
                echo " - INVALID    (DROP - IN)"
                    ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP -m comment --comment "DROP anything marked INVALID"
                echo " - Fragmented (DROP - IN)"
                    ip6tables -A INPUT -m frag -j DROP -m comment --comment "DROP Fragmented"
                echo " - NEW != SYN (DROP - IN)"
                    ip6tables -A INPUT -p tcp ! --syn -m conntrack --ctstate NEW -j DROP -m comment --comment "DROP any NEW connections that do NOT start with SYN"
                echo " - SYN Flood  (DROP - IN)"
                    ip6tables -A INPUT -p tcp --syn -m hashlimit --hashlimit-name synFlood --hashlimit-above 30/s -j DROP -m comment --comment "LIMIT SYN to 30/sec"

        echo -e "\nACCEPT everything marked RELATED/ESTABLISHED"
            ip6tables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT incoming RELATED/ESTABLISHED"
            ip6tables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT outgoing RELATED/ESTABLISHED"
    
        echo "ACCEPT everything on loopback"
            ip6tables -A INPUT -i lo -j ACCEPT -m comment --comment "ACCEPT all incoming on loopback"
            ip6tables -A OUTPUT -o lo -j ACCEPT -m comment --comment "ACCEPT all outgoing on loopback"
}