#!/bin/bash

function firewall_home_limited_no_local
{
    firewall_v6_support_basic

    echo -e "\n\e[44mDeploying Limited Home No Local Firewall Rules\e[49m"

    echo -e "\nSetting default policy to DROP"
        iptables -P OUTPUT DROP
        iptables -P INPUT DROP
        iptables -P FORWARD DROP

    echo -e "\nFlushing all chains"
        iptables -F

    echo -e "\nDROP bad packets In"
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

    echo -e "\nDROP Local In"
        echo " - Class A"
            iptables -A INPUT -s 10.0.0.0/8 -j DROP -m comment --comment "DROP from Private Class A"
        echo " - Class B"
            iptables -A INPUT -s 172.16.0.0/12 -j DROP -m comment --comment "DROP from Private Class B" 
        echo " - Class C"
            iptables -A INPUT -s 192.168.0.0/16 -j DROP -m comment --comment "DROP from Private Class C"
        echo " - APIPA"
            iptables -A INPUT -s 169.254.0.0/16 -j DROP -m comment --comment "DROP from APIPA" 

    echo -e "\nDROP Local Out"
        echo " - Class A"
            iptables -A OUTPUT -d 10.0.0.0/8 -j DROP -m comment --comment "DROP to Private Class A"
        echo " - Class B"
            iptables -A OUTPUT -d 172.16.0.0/12 -j DROP -m comment --comment "DROP to Private Class B" 
        echo " - Class C"
            iptables -A OUTPUT -d 192.168.0.0/16 -j DROP -m comment --comment "DROP to Private Class C"
        echo " - APIPA"
            iptables -A OUTPUT -d 169.254.0.0/16 -j DROP -m comment --comment "DROP to APIPA" 

    echo -e "\nACCEPT everything marked RELATED/ESTABLISHED"
        iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT incoming RELATED/ESTABLISHED"
        iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT outgoing RELATED/ESTABLISHED"

    echo "ACCEPT everything on loopback"
        iptables -A INPUT -s 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all incoming on loopback"
        iptables -A OUTPUT -d 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all outgoing on loopback"

    echo -e "\nACCEPT services OUT"
        echo " - HTTP       (ACCEPT - OUT)"
            iptables -A OUTPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing http"
        echo " - HTTPS      (ACCEPT - OUT)"
            iptables -A OUTPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing https"
        echo " - DNS        (ACCEPT - OUT)"
            iptables -A OUTPUT -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns"
    
    firewall_persistentSave
}