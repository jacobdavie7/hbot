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

        echo -e "\nDROP spoofed loopback"
            ip6tables -A INPUT -s ::1/128 ! -i lo -j DROP -m comment --comment "DROP ::1/128 not from loopback"
        
        echo -e "\nACCEPT everything on loopback" # needed on ipv6 to login
            ip6tables -A INPUT -i lo -s ::1/128 -d ::1/128 -j ACCEPT -m comment --comment "ACCEPT all v6 incoming on loopback"
            ip6tables -A OUTPUT -o lo -s ::1/128 -d ::1/128 -j ACCEPT -m comment --comment "ACCEPT all v6 outgoing on loopback"

#        echo -e "\nDROP bad packets"
#                echo " - XMAS       (DROP - IN)"
#                    ip6tables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP -m comment --comment "DROP outgoing XMAS"
#                echo " - NULL       (DROP - IN)"
#                    ip6tables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP -m comment --comment "DROP outgoing NULL"
#                echo " - INVALID    (DROP - IN)"
#                    ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP -m comment --comment "DROP anything marked INVALID"
#                echo " - Fragmented (DROP - IN)"
#                    ip6tables -A INPUT -m frag -j DROP -m comment --comment "DROP Fragmented"
#                echo " - NEW != SYN (DROP - IN)"
#                    ip6tables -A INPUT -p tcp ! --syn -m conntrack --ctstate NEW -j DROP -m comment --comment "DROP any NEW connections that do NOT start with SYN"
#                echo " - SYN Flood  (DROP - IN)"
#                    ip6tables -A INPUT -p tcp --syn -m hashlimit --hashlimit-name synFlood --hashlimit-above 30/s -j DROP -m comment --comment "LIMIT SYN to 30/sec"

#            ip6tables -A INPUT -s fc00::/7 -j DROP -m comment --comment "DROP from unique local address"
#            ip6tables -A OUTPUT -d fc00::/7 -j DROP -m comment --comment "DROP to unique local address"
#
#            ip6tables -A INPUT -s fd00::/8 -j DROP -m comment --comment "DROP from unique local address"
#            ip6tables -A OUTPUT -d fd00::/8 -j DROP -m comment --comment "DROP to unique local address"
#
#            ip6tables -A INPUT -s ::/128 -j DROP -m comment --comment "DROP from unspecified"
#            ip6tables -A OUTPUT -d ::/128 -j DROP -m comment --comment "DROP to unspecified"
#
#            ip6tables -A INPUT -s ::ffff:0:0/96 -j DROP -m comment --comment "DROP from ipv4 to ipv6 map"
#            ip6tables -A OUTPUT -d ::ffff:0:0/96 -j DROP -m comment --comment "DROP to ipv4 to ipv6 map"
#            
#            ip6tables -A INPUT -s fe80::/10 -j DROP -m comment --comment "DROP from link-local"
#            ip6tables -A OUTPUT -d fe80::/10 -j DROP -m comment --comment "DROP to link-local"
#        
#        echo -e "\nACCEPT everything marked RELATED/ESTABLISHED"
#            ip6tables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT incoming RELATED/ESTABLISHED"
#            ip6tables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT outgoing RELATED/ESTABLISHED"
#    
#        echo "ACCEPT everything on loopback"
#            ip6tables -A INPUT -i lo -j ACCEPT -m comment --comment "ACCEPT all incoming on loopback"
#            ip6tables -A OUTPUT -o lo -j ACCEPT -m comment --comment "ACCEPT all outgoing on loopback"

}