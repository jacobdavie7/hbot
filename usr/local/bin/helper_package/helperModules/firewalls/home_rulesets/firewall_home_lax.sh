#!/bin/bash

function firewall_home_lax
{
    firewall_header
    
    echo -e "\n\e[44mDeploying Lax Home Firewall Rules\e[49m"
        
        echo -e "\nSetting default OUTPUT policy to ACCEPT"    
            iptables -P OUTPUT ACCEPT

    firewall_persistentSave
}