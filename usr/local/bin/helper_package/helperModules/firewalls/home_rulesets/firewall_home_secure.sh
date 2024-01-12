#!/bin/bash

function firewall_home_secure
{
    firewall_header
    
    echo -e "\n\e[44mDeploying Secure Home Firewall Rules\e[49m"

    echo -e "\nACCEPT services OUT"
        echo " - HTTPS             (ACCEPT - OUT)"
            iptables -A OUTPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing https"
        echo " - DNS over TLS      (ACCEPT - OUT)"
            iptables -A OUTPUT -p tcp --dport 853 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns over tls"
   
   firewall_persistentSave
}