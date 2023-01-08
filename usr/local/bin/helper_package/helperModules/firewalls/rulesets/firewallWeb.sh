#!/bin/bash

function firewallWebServer
{
    echo -e "\nSetting default policy to DROP"
        iptables -P OUTPUT DROP
        ip6tables -P OUTPUT DROP

        iptables -P INPUT DROP
        ip6tables -P INPUT DROP

        iptables -P FORWARD DROP
        ip6tables -P FORWARD DROP
    
    echo -e "\nFlushing all chains"
    echo "   Includes IP's banned by Fail2Ban"
        iptables -F
        ip6tables -F

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

    echo -e "\nALLOW services IN"
        echo " - ssh       (IN)"
            iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming ssh"
        echo " - http      (IN)"
            iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming http"
        echo " - https     (IN)"
            iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming https"
        #echo " - ntp      (OUT)"
            #iptables -A OUTPUT -p udp --dport 123 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ntp"

    # Allow Data Out -> All Handled on a per-user basis
        echo -e "\nALLOW services OUT (per-user basis)"

            # Root Only
                echo " - ssh       root         (OUT)"
                    iptables -A OUTPUT -p tcp --dport 22 -m owner --uid-owner root -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ssh for root"
                echo " - ping      root         (OUT)"
                    iptables -A OUTPUT -p icmp --icmp-type 8 -m owner --uid-owner root -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ping request for root"
                echo " - Speedtest root         (OUT)"
                    iptables -A OUTPUT -p tcp --dport 8080 -m owner --uid-owner root -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing Speedtest (8080) for root"
            
            # Loop for services enabled across multiple accounts
                USERS=( root _apt www-data )
                for U in "${USERS[@]}"
                do
                    echo " - http      $U         (OUT)"
                        iptables -A OUTPUT -p tcp --dport 80 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing http for $U"
                    echo " - https     $U         (OUT)"
                        iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing https for $U"
                    echo " - dns       $U         (OUT)"
                        iptables -A OUTPUT -p udp --dport 53 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns for $U"
                done

            # www-data only
                echo " - smtp      www-data         (OUT)"
                    iptables -A OUTPUT -p tcp --dport 587 -m owner --uid-owner www-data -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing smtp for www-data"
            
    #    #Figure out if these need to go on input or output (exept for ping), for ones going out, look into what account needs to do so to use owner mod
    #        echo "ALLOW ICMP"
    #            echo " - Dest. unreachable  (IN)"
    #                iptables -A INPUT -p icmp --icmp-type 3  -m limit --limit 1/s --limit-burst 2 -j ACCEPT -m comment --comment "Limited ACCEPT ICMP IN Dest. unreachable (3)"
    #            echo " - Dest. unreachable  (OUT)"
    #                iptables -A OUTPUT -p icmp --icmp-type 3 -m limit --limit 1/s --limit-burst 2 -j ACCEPT -m comment --comment "Limited ACCEPT ICMP OUT Dest. unreachable (3)"
    #            echo " - Redirect           (IN)"
    #                iptables -A INPUT -p icmp --icmp-type 5 -m limit --limit 1/s --limit-burst 2 -j ACCEPT -m comment --comment "Limited ACCEPT ICMP IN Redirect (5)"
    #            echo " - Redirect           (OUT)"
    #                iptables -A OUTPUT -p icmp --icmp-type 5 -m limit --limit 1/s --limit-burst 2 -j ACCEPT -m comment --comment "Limited ACCEPT ICMP OUT Redirect (5)"
    #            echo " - Route Advert       (IN)"
    #                iptables -A INPUT -p icmp --icmp-type 9 -m limit --limit 1/s --limit-burst 2 -j ACCEPT -m comment --comment "Limited ACCEPT ICMP IN Route Advert (9)"
    #            echo " - Route Advert       (OUT)"
    #                iptables -A OUTPUT -p icmp --icmp-type 9 -m limit --limit 1/s --limit-burst 2 -j ACCEPT -m comment --comment "Limited ACCEPT ICMP OUT Route Advert (9)"
    #            echo " - Time Exce.         (IN)"
    #                iptables -A INPUT -p icmp --icmp-type 11  -m limit --limit 1/s --limit-burst 2 -j ACCEPT -m comment --comment "Limited ACCEPT ICMP IN Time Exce. (11)"
    #            echo " - Time Exce.         (OUT)"
    #                iptables -A OUTPUT -p icmp --icmp-type 11 -m limit --limit 1/s --limit-burst 2 -j ACCEPT -m comment --comment "Limited  ACCEPT ICMP OUT Time Exce. (11)"
            
    firewallPersistentSave

    echo -e "\n\e[91mDon't Forget About Edge Firewall!\e[39m"
    echo -e "\n\e[31mSSH should be alive, if frozen and not coming back, try SSHing in a new terminal\e[39m\n"
}