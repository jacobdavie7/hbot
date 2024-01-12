#!/bin/bash

function firewall_home
{
    firewall_header

    echo -e "\n\e[44mDeploying Home Firewall Rules\e[49m"

    echo -e "\nCreate STEAM_OUT chain"
        iptables -N STEAM_OUT

    echo -e "\nDROP steam OUT" # needs to be before related/established, steam will intitiate on both sides and remote play will match on related/established. Needs to be BEFORE. Even with dropping these before, steam can lauch the game on remote, but will not be able to get a virtual desktop connection 
            echo "   - Remote Play UPD (DROP - OUT)" 
                iptables -A OUTPUT -p udp --dport 27031:27036 -m conntrack --ctstate NEW -j DROP -m comment --comment "DROP new outgoing Steam remote play udp"
            echo "   - Remote Play TCP (DROP - OUT)" 
                iptables -A OUTPUT -p tcp --dport 27036 -m conntrack --ctstate NEW -j DROP -m comment --comment "DROP new outgoing Steam remote play tcp"
            echo "   - SRCDS Rcon      (DROP - OUT)"
                iptables -A OUTPUT -p tcp --dport 27015 -m conntrack --ctstate NEW -j DROP -m comment --comment "DROP new outgoing Steam - source dedicated server remote console"
            echo "   - SRCDS Rcon      (DROP - OUT)"
            
    echo -e "\nACCEPT services OUT"
        echo " - SSH        (ACCEPT - OUT)"
            iptables -A OUTPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ssh"
        echo " - HTTP       (ACCEPT - OUT)"
            iptables -A OUTPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing http"
        echo " - HTTPS      (ACCEPT - OUT)"
            iptables -A OUTPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing https"
        echo " - DNS        (ACCEPT - OUT)"
            iptables -A OUTPUT -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns"
        echo " - PING       (ACCEPT - OUT)"
            iptables -A OUTPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ping request"
        echo " - Wireguard  (ACCEPT - OUT)"
            iptables -A OUTPUT -p udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing wireguard"
        echo " - WG-PQ      (ACCEPT - OUT)"
            iptables -A OUTPUT -p tcp --dport 1337 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing mullvad post-quantum"
        echo " - HTTP Dev   (ACCEPT - OUT)"
            iptables -A OUTPUT -p tcp --dport 8080 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing HTTP Dev on 8080"
        echo " - ProxMox VE (ACCEPT - OUT)"
            iptables -A OUTPUT -p tcp --dport 8006 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ProxMox VE Managment"
        echo " - ProxMox BS (ACCEPT - OUT)"
            iptables -A OUTPUT -p tcp --dport 8007 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ProxMox Backup Managment"
        echo " - uptimeKuma (ACCEPT - OUT)"
            iptables -A OUTPUT -p tcp --dport 3001 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing Uptime Kuma"
        echo " - NTP        (ACCEPT - OUT)"
            iptables -A OUTPUT -p udp --dport 123 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing NTP"
        echo " - ZeroTier   (ACCEPT - OUT)"
            iptables -A OUTPUT -p udp --dport 9993 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing udp ZeroTier"
        echo " - RTC"
            echo "   - VoIP STUN         (ACCEPT - OUT)"
                iptables -A OUTPUT -p udp --dport 3478 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing WebRTC to video conf."
            echo "   - Google Meet       (ACCEPT - OUT)"
                iptables -A OUTPUT -p udp --dport 19302:19309 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing WebRTC to G-Meet fallback"
            echo "   - Discord           (ACCEPT - OUT)"
                iptables -A OUTPUT -p udp --dport 50000:50050 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing RTC to Discord"
        echo " - Steam"
            echo "   - Auth/Down/Client  (ACCEPT - OUT)" 
                iptables -A OUTPUT -p udp --dport 27000:27100 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing Steam for game, auth, down, client, P2P, VC"
            echo "   - Auth/Down TCP     (ACCEPT - OUT)"
                iptables -A OUTPUT -p tcp --dport 27015:27050 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing to Steam for auth and downloads TCP backup"
            echo "   - Client/VC/P2P     (ACCEPT - OUT)"
                iptables -A OUTPUT -p udp --match multiport --dports 3478,4379:4380 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing to Steam for client, VC, P2P"

    firewall_persistentSave
}