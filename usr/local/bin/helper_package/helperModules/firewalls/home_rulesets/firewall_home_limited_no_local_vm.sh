#!/bin/bash

function firewall_home_limited_no_local_vm
{
    firewall_header

    echo -e "\n\e[44mDeploying Limited Home No Local Firewall Rules\e[49m"

    echo -e "\nDROP Local In"
        echo " - Class A"
            iptables -A INPUT -s 10.0.0.0/8 -j DROP -m comment --comment "DROP from Private Class A"
        echo " - Class B"
            iptables -A INPUT -s 172.16.0.0/12 -j DROP -m comment --comment "DROP from Private Class B" 
        echo " - Class C"
            iptables -A INPUT -s 192.168.0.0/16 -j DROP -m comment --comment "DROP from Private Class C"
        echo " - APIPA"
            iptables -A INPUT -s 169.254.0.0/16 -j DROP -m comment --comment "DROP from APIPA" 

    echo -e "\nACCEPT Local DNS Out"
        iptables -A OUTPUT -p udp -d 10.0.4.1 --dport 53 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns to local"

    echo -e "\nDROP Local Out"
        echo " - Class A"
            iptables -A OUTPUT -d 10.0.0.0/8 -j DROP -m comment --comment "DROP to Private Class A"
        echo " - Class B"
            iptables -A OUTPUT -d 172.16.0.0/12 -j DROP -m comment --comment "DROP to Private Class B" 
        echo " - Class C"
            iptables -A OUTPUT -d 192.168.0.0/16 -j DROP -m comment --comment "DROP to Private Class C"
        echo " - APIPA"
            iptables -A OUTPUT -d 169.254.0.0/16 -j DROP -m comment --comment "DROP to APIPA" 

    echo -e "\nACCEPT services OUT"
        echo " - HTTP       (ACCEPT - OUT)"
            iptables -A OUTPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing http"
        echo " - HTTPS      (ACCEPT - OUT)"
            iptables -A OUTPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing https"
        echo " - DNS        (ACCEPT - OUT)"
            iptables -A OUTPUT -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns"
    
    firewall_persistentSave
}