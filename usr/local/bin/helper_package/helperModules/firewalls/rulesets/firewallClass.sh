#!/bin/bash

function firewallClass
{ 
    echo -e "\n\e[44mDeploying Home Firewall Rules\e[49m"

    echo -e "\nSetting default policy to DROP"
        iptables -P OUTPUT DROP
        iptables -P INPUT DROP
        iptables -P FORWARD DROP

    echo -e "\nFlushing all chains"
        iptables -F

    echo -e "\nDROP bad packets IN"
        echo " - XMAS       (DROP - IN)"
            iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP -m comment --comment "DROP outgoing XMAS"
        echo " - NULL       (DROP - IN)"
            iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP -m comment --comment "DROP outgoing NULL"
        echo " - INVALID    (DROP - IN)"
            iptables -A INPUT -m conntrack --ctstate INVALID -j DROP -m comment --comment "DROP anything marked INVALID"
        echo " - Fragmented (DROP - IN)"
            iptables -A INPUT -f -j DROP -m comment --comment "DROP Fragmented"
        echo " - NEW != SYN (DROP - IN)"
            iptables -A INPUT -p tcp ! --syn -m conntrack --ctstate NEW -j DROP -m comment --comment "DROP any NEW connections that do NOT start with SYN"
        echo " - SYN Flood  (DROP - IN)"
            iptables -A INPUT -p tcp --syn -m hashlimit --hashlimit-name synFlood --hashlimit-above 30/s -j DROP -m comment --comment "LIMIT SYN to 30/sec"

    echo -e "\nACCEPT everything marked RELATED/ESTABLISHED"
        iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT incoming RELATED/ESTABLISHED"
        iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT outgoing RELATED/ESTABLISHED"
    
    echo "ACCEPT everything on loopback"
        iptables -A INPUT -s 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all incoming on loopback"
        iptables -A OUTPUT -d 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all outgoing on loopback"

    echo -e "\nACCEPT services IN"
        echo " - SSH        (ACCEPT - IN)"
            iptables -A INPUT -p tcp 10.1.1.246 --dport 22 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new INCOMING ssh from 10.1.1.246"
        echo " - PING       (ACCEPT - IN)"
            iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT incoming ping request"

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
        echo " - NTP        (ACCEPT - OUT)"
            iptables -A OUTPUT -p udp --dport 123 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing NTP"
        echo " - ZeroTier   (ACCEPT - OUT)"
            iptables -A OUTPUT -p udp --dport 9993 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing udp ZeroTier"
        echo " - ia captive (ACCEPT - OUT)"
            iptables -A OUTPUT -p tcp --dport 6082 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing tcp ia captive portal"
        echo " - vCenter    (ACCEPT - OUT)"
            iptables -A OUTPUT -p tcp --dport 5480 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing tcp vmware esxi vcenter"
        echo " - RTC"
            echo "   - VoIP STUN         (ACCEPT - OUT)"
                iptables -A OUTPUT -p udp --dport 3478 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing WebRTC to video conf."
            echo "   - Google Meet       (ACCEPT - OUT)"
                iptables -A OUTPUT -p udp --dport 19302:19309 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing WebRTC to G-Meet fallback"
            echo "   - Discord           (ACCEPT - OUT)"
                iptables -A OUTPUT -p udp --dport 50000:50050 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing RTC to Discord"
 

    firewallv6Basic    
    # firewallPersistentSave # Don't make this persistent

}