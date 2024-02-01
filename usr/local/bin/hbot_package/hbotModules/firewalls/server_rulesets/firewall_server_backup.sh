#!/bin/bash

function firewall_server_pbs
{
    firewall_header

    echo -e "\n\e[44mDeploying Proxmox Backup Server Firewall Rules\e[49m"

    echo -e "\nALLOW services IN"
        echo " - pbs 8007  (IN)"
            iptables -A INPUT -p tcp -s 10.0.40.0/24,10.0.90.0/24 --dport 8007 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming pbs 8007 for devices/vpn"

    echo -e "\nALLOW services OUT"
        echo -e " - ACCEPT http OUT for _apt"
            iptables -A OUTPUT -p tcp --dport 80 -m owner --uid-owner _apt -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing http for _apt"
        echo -e " - ACCEPT https OUT for _apt"
            iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner _apt -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing https for _apt"
        echo -e " - ACCEPT http OUT for _apt"
            iptables -A OUTPUT -p udp --dport 53 -m owner --uid-owner _apt -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns for _apt"
    
    firewall_persistentSave

    echo -e "\n\e[91mDon't Forget About Edge Firewall!\e[39m"
    echo -e "\n\e[31mSSH should be alive, if frozen and not coming back, try SSHing in a new terminal\e[39m\n"
}