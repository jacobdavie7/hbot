#!/bin/bash

function firewall_home_lax
{
    firewall_header
    
    echo -e "\n\e[44mDeploying Lax Home Firewall Rules\e[49m"
        
        echo -e "\nSetting default OUTPUT policy to ACCEPT"    
            iptables -P OUTPUT ACCEPT

    echo -e "\n\e[31mDoes not call persistent save, WILL BE LOST ON RESTART\e[39m\n"
}