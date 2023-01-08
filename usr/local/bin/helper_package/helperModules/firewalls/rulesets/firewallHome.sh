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

    USER_ACCOUNT=$(cat /etc/passwd | grep "1000" | cut -d':' -f1)

    USERS=( $USER_ACCOUNT root _apt _flatpak )
    for U in "${USERS[@]}"
    do
        echo " - HTTP       $U      (OUT)"
            iptables -A OUTPUT -p tcp --dport 80 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing http for $U"
        echo " - HTTPS      $U      (OUT)"
            iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing https for $U"
        echo " - DNS        $U      (OUT)"
            iptables -A OUTPUT -p udp --dport 53 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns for $U"
    done

    USERS=( $USER_ACCOUNT root )
    for U in "${USERS[@]}"
    do
        echo " - SSH        $U      (OUT)"
            iptables -A OUTPUT -p tcp --dport 22 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ssh for $U"        
        echo " - PING       $U      (OUT)"
            iptables -A OUTPUT -p icmp --icmp-type 8 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ping request for $U"
        echo " - Wireguard      $U      (OUT)"
            iptables -A OUTPUT -p udp --dport 51820 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new wireguard for $U"
        echo " - HTTP Dev   $U      (OUT)"
            iptables -A OUTPUT -p tcp --dport 8080 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new HTTP Dev on 8080 (speedtest) for $U"
        echo " - RTC        $U      (OUT)"
            echo "   - VoIP STUN       $U      (OUT)"
                iptables -A OUTPUT -p udp --dport 3478 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing WebRTC to video conf. for $U"
            echo "   - Google Meet     $U      (OUT)"
                iptables -A OUTPUT -p udp --dport 19302:19309 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing WebRTC to G-Meet fallback for $U"
            echo "   - Discord         $U      (OUT)"
                iptables -A OUTPUT -p udp --dport 50000:50050 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing RTC to Discord for $U"
        echo " - Steam      $U      (OUT)"
            echo "   - Auth/Down/Client $U      (OUT)" 
                iptables -A OUTPUT -p udp --dport 27000:27100 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing to Steam for game traffic, auth, downloads, client, P2P, and VC for $U"
            echo "   - Auth/Down TCP    $U      (OUT)"
                iptables -A OUTPUT -p tcp --dport 27015:27050 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing to Steam for auth and downloads TCP backup for $U"
            echo "   - Client           $U      (OUT)"
                iptables -A OUTPUT -p udp --dport 4380 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing to Steam for client for $U"
            echo "   - Voice Chat/P2P   $U      (OUT)"
                iptables -A OUTPUT -p udp --dport 3478 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing to Steam for Voice Chat and P2P for $U"
                iptables -A OUTPUT -p udp --dport 4379:4380 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing to Steam for Voice Chat and P2P for $U"
    done
        
    firewallv6Basic    
    firewallPersistentSave

}