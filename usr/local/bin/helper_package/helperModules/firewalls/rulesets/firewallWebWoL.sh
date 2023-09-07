#!/bin/bash

function firewallWoL
{
    echo -e "\nSetting default policy to DROP"
        iptables -P OUTPUT DROP
        ip6tables -P OUTPUT DROP

        iptables -P INPUT DROP
        ip6tables -P INPUT DROP

        iptables -P FORWARD DROP
        ip6tables -P FORWARD DROP
    
    echo -e "\nFlushing all chains"
        iptables -F
        ip6tables -F

    echo -e "\nDROP bad packets"
        echo " - XMAS       (DROP - IN)"
            iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP -m comment --comment "DROP outgoing XMAS"
        echo " - NULL       (DROP - IN)"
            iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP -m comment --comment "DROP outgoing NULL"
        echo " - INVALID    (DROP - IN)"
            iptables -A INPUT -m conntrack --ctstate INVALID -j DROP -m comment --comment "DROP anything marked INVALID"
        echo " - Fragmented (DROP - IN)"
            iptables -A INPUT -f -j DROP -m comment --comment "DROP Fragmented"
        echo " - NEW != SYN (DROP - IN)"
            iptables -A INPUT -p tcp ! --syn -m conntrack --ctstate NEW -j DROP -m comment --comment "DROP any NEW connections that do NOT start with SYN"
        echo " - SYN Flood  (DROP - IN)"
            iptables -A INPUT -p tcp --syn -m hashlimit --hashlimit-name synFlood --hashlimit-above 30/s -j DROP -m comment --comment "LIMIT SYN to 30/sec"

    echo -e "\nACCEPT everything marked RELATED/ESTABLISHED"
        iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT incoming RELATED/ESTABLISHED"
        iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT outgoing RELATED/ESTABLISHED"

    echo "ACCEPT everything on loopback"
        iptables -A INPUT -s 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all incoming on loopback"
        iptables -A OUTPUT -d 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all outgoing on loopback"

        # in
        echo -e "\nACCEPT SSH in"
            iptables -A INPUT -p tcp -s 10.0.4.0/24,10.0.9.0/24 --dport 22 -j ACCEPT -m comment --comment "ACCEPT new incoming ssh"

        # out
        echo -e "\nDROP local"
            iptables -A OUTPUT -s 10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,169.254.0.0/16 -j DROP -m comment --comment "DROP local"

        echo -e "\nACCEPT HTTPS out for www-data"
            iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner _apt -j ACCEPT -m comment --comment "ACCEPT new outgoing https for www-data"
        echo -e "\nACCEPT DNS out for www-data"
            iptables -A OUTPUT -p udp --dport 53 -m owner --uid-owner _apt -j ACCEPT -m comment --comment "ACCEPT new outgoing dns for www-data"

    firewallPersistentSave

}