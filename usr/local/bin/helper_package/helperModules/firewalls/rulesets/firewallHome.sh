#!/bin/bash

function firewallHome
{ 
    echo -e "\n\e[44mDeploying Home Firewall Rules\e[49m"

    echo -e "\nSetting default policy to DROP"
        iptables -P OUTPUT DROP
        iptables -P INPUT DROP
        iptables -P FORWARD DROP

    echo -e "\nFlushing all chains"
        iptables -F

    echo -e "\nDROP bad packets"
            echo " - XMAS       (IN)"
                iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP -m comment --comment "DROP outgoing XMAS"
            echo " - NULL       (IN)"
                iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP -m comment --comment "DROP outgoing NULL"
            echo " - INVALID    (IN)"
                iptables -A INPUT -m conntrack --ctstate INVALID -j DROP -m comment --comment "DROP anything marked INVALID"
            echo " - Fragmented (IN)"
                iptables -A INPUT -f -j DROP -m comment --comment "DROP Fragmented"
            echo " - NEW != SYN (IN)"
                iptables -A INPUT -p tcp ! --syn -m conntrack --ctstate NEW -j DROP -m comment --comment "DROP any NEW connections that do NOT start with SYN"
            echo " - SYN Flood  (IN)"
                iptables -A INPUT -p tcp --syn -m hashlimit --hashlimit-name synFlood --hashlimit-above 30/s -j DROP -m comment --comment "LIMIT SYN to 30/sec"

    echo -e "\nALLOW anything marked RELATED/ESTABLISHED"
        iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT incoming RELATED/ESTABLISHED"
        iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT outgoing RELATED/ESTABLISHED"
    
    echo "ALLOW everything on loopback"
        iptables -A INPUT -s 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all incoming on loopback"
        iptables -A OUTPUT -d 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all outgoing on loopback"

    echo -e "\nALLOW services OUT"
        echo " - SSH        (OUT)"
            iptables -A OUTPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ssh"
        echo " - HTTP       (OUT)"
            iptables -A OUTPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing http"
        echo " - HTTPS      (OUT)"
            iptables -A OUTPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing https"
        echo " - DNS        (OUT)"
            iptables -A OUTPUT -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns"
        echo " - PING       (OUT)"
            iptables -A OUTPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ping request"
        echo " - CUPS       (OUT)"
            iptables -A OUTPUT -p tcp --dport 631 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing cups"
        echo " - Wireguard  (OUT)"
            iptables -A OUTPUT -p udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new wireguard"
        echo " - HTTP Dev   (OUT)"
            iptables -A OUTPUT -p tcp --dport 8080 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new HTTP Dev on 8080 (speedtest)"
        echo " - RTC        (OUT)"
            echo "   - VoIP STUN         (OUT)"
                iptables -A OUTPUT -p udp --dport 3478 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing WebRTC to video conf."
            echo "   - Google Meet       (OUT)"
                iptables -A OUTPUT -p udp --dport 19302:19309 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing WebRTC to G-Meet fallback"
            echo "   - Discord           (OUT)"
                iptables -A OUTPUT -p udp --dport 50000:50050 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing RTC to Discord"
        echo " - Steam      (OUT)"
            echo "   - Auth/Down/Client  (OUT)" 
                iptables -A OUTPUT -p udp --dport 27000:27100 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing to Steam for game traffic, auth, downloads, client, P2P, and VC"
            echo "   - Auth/Down TCP     (OUT)"
                iptables -A OUTPUT -p tcp --dport 27015:27050 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing to Steam for auth and downloads TCP backup"
            echo "   - Client            (OUT)"
                iptables -A OUTPUT -p udp --dport 4380 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing to Steam for client"
            echo "   - Voice Chat/P2P    (OUT)"
                iptables -A OUTPUT -p udp --dport 3478 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing to Steam for Voice Chat and P2P"
                iptables -A OUTPUT -p udp --dport 4379:4380 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing to Steam for Voice Chat and P2P"
    
    firewallPersistentSave
}