#!/bin/bash

function firewall_home_lax_in
{
    firewall_header
    
    echo -e "\n\e[44mDeploying Lax IN Home Firewall Rules\e[49m"
        
        echo -e "\nSetting default OUTPUT policy to ACCEPT"    
            iptables -P OUTPUT ACCEPT

        echo -e "\nACCEPT services IN"
            echo " - SSH        (ACCEPT - IN)"
                iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming ssh"
            echo " - PING       (ACCEPT - IN)"
                iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ping request"

        echo -e "\n\e[31mDoes not call persistent save, WILL BE LOST ON RESTART\e[39m\n"
}