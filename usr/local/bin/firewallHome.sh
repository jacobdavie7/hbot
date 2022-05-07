#!/bin/bash

function firewallHome
{
    echo -e "\n\e[44mDeploying Home Firewall Rules\e[49m"

    echo "Flushing all chains"
        sudo -i iptables -F

    echo "Setting default policy to DROP"
        sudo -i iptables -P OUTPUT DROP
        sudo -i iptables -P INPUT DROP
        sudo -i iptables -P FORWARD DROP

    echo "ALLOW anything marked RELATED/ESTABLISHED"
        sudo -i iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT incoming RELATED/ESTABLISHED"
        sudo -i iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT outgoing RELATED/ESTABLISHED"
    
    echo "ALLOW everything on loopback"
        sudo -i iptables -A INPUT -s 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all incoming on loopback"
        sudo -i iptables -A OUTPUT -d 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all outgoing on loopback"

    echo "DROP anything marked INVALID"
        sudo -i iptables -A INPUT -m conntrack --ctstate INVALID -j DROP -m comment --comment "DROP anything marked INVALID"

    echo "ALLOW services OUT"
        echo " - SSH        (OUT)"
            sudo -i iptables -A OUTPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ssh"
        echo " - HTTP       (OUT)"
            sudo -i iptables -A OUTPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing http"
        echo " - HTTPS      (OUT)"
            sudo -i iptables -A OUTPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing https"
        echo " - DNS        (OUT)"
            sudo -i iptables -A OUTPUT -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns"
        echo " - PING       (OUT)"
            sudo -i iptables -A OUTPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ping request"
        echo " - CUPS       (OUT)"
            sudo -i iptables -A OUTPUT -p tcp --dport 631 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing cups"
        echo " - Meet RTC   (OUT)"
            sudo -i iptables -A OUTPUT -p udp --dport 19302:19309 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing RTC to Google Meet"
        echo " - Dis. RTC   (OUT)"
            sudo -i iptables -A OUTPUT -p udp --dport 50000:50050 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing RTC to Discord"
        echo " - STUN RC    (OUT)"
            sudo -i iptables -A OUTPUT -p udp --dport 3478 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing STUN to RC Desktop"
        echo " - CLI Speed  (OUT)"
            sudo -i iptables -A OUTPUT -p tcp --dport 8080 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing Speedtest (8080)"
}

