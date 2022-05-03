#!/bin/bash

function updater ()
{
    echo -e "Executing 'Updater' Function"
    # apt
        echo -e "\n\e[95;4mapt\e[39;24m"
        sudo apt update
        echo -e "\n\e[4mApt Packages that can be Upgraded:\e[39;24m"
        apt list --upgradeable

        echo -e "\n\e[4mRun Apt Upgradeable? (y or n)\e[39;24m"
        read ANS
        if [ "$ANS" == "y" ]; then
            sudo apt upgrade -y

            echo -e "\n\e[4mRun Apt autoremove? (y or n)\e[39;24m"
            read ANS
            if [ "$ANS" == "y" ]; then
                sudo apt autoremove -y
            fi
        fi
    # flatpak
        echo -e "\n\e[95;4mflatpak\e[39;24m"
        flatpak update

    # snap
        echo -e "\n\e[95;4msnap\e[39;24m"
        sudo snap refresh
}

function monitors ()
{
    echo -e "Executing 'Monitors' Function"

    #Clone GitHub Repo
        #git clone https://github.com/AdnanHodzic/displaylink-debian.git /tmp/displaylink-debian
        #./tmp/displaylink-debian/displaylink-debian.sh

    # Run xrandr --listproviders to view monitor outputs. Provider 0 should be GPU, 1-4 should be the adapters.
    # Should look like something below:
    # Provider 1: id: 0x138 cap: 0x2, Sink Output crtcs: 1 outputs: 1 associated providers: 0 name:modesetting
    # ...Goes to provider 4, looks like provider 1                                          ^ This 0 should change to 1 after the commands below

    # Enable DisplayLink Adapter
        xrandr --setprovideroutputsource 1 0
        xrandr --setprovideroutputsource 2 0
        xrandr --setprovideroutputsource 3 0
        xrandr --setprovideroutputsource 4 0

    #run xrandr to view adapter names (DVI-I-1-1, DP-0)
    
    #Center Monitor (Primary)                                       #Need to use pos to correctly line up top monitor. If only use --pos for top monitor, all the monitors will be on the same x level. 
        xrandr --output HDMI-0 --primary --pos 1440x1080 --auto     #                   --pos 1440x1080
    #Left Monitor
        xrandr --output DP-0 --pos 0x1080 --auto                    #--left-of HDMI-0   --pos 0x1080
    #Right Monitor
        xrandr --output DVI-D-0 --pos 3120x1080 --auto              #--right-of HDMI-0  --pos 3120x1080
    #Top Monitor
        xrandr --output DVI-I-1-1 --pos 1320x0 --auto               #--above HDMI-0     --pos 1320x0

    echo -e "\tIf the monitor is still NOT functioning and drivers ARE installed (from GitHub), the USB DisplayLink adapter may need to be reseated."
    # https://github.com/AdnanHodzic/displaylink-debian/blob/master/post-install-guide.md
}

function drawing ()
{
    echo -e "Executing 'Drawing' Function"

    #Append 70-wacom.conf
        XORG_APPEND=$(cat /usr/share/X11/xorg.conf.d/70-wacom.conf | grep "S620" | cut -d' ' -f2,3 | sed 's/ //g')
            if [ "$XORG_APPEND" != "GaomonS620" ]; then
                sudo chmod 664 /usr/share/X11/xorg.conf.d/70-wacom.conf
                echo -e '\n\n# Gaomon S620\nSection "InputClass"\n\tIdentifier "GAOMON Gaomon Tablet"\n\tMatchUSBID  "256c:006d"\n\tMatchDevicePath "/dev/input/event*"\n\tDriver "wacom"\nEndSection' >> /usr/share/X11/xorg.conf.d/70-wacom.conf
                sudo chmod 644 /usr/share/X11/xorg.conf.d/70-wacom.conf
                echo -e "Need to Restart/Logout Before Continuing. Do so and Run Script Again"
            fi

	#Find Input ID's (used to map to single display)
		INPUT_ID_PEN=$(xsetwacom --list | grep "GAOMON Gaomon Tablet Pen stylus"| cut -f2 | cut -d' ' -f2)
		INPUT_ID_PAD=$(xsetwacom --list | grep "GAOMON Gaomon Tablet Pad pad"| cut -f2 | cut -d' ' -f2)

	#Map Wacom Input to Single Primary Display
		xinput map-to-output $INPUT_ID_PEN HDMI-0
		xinput map-to-output $INPUT_ID_PAD HDMI-0

	#Key Mapping
		xsetwacom --set 'GAOMON Gaomon Tablet Pad pad' Button 1 key "+ctrl +shift p -shift -ctrl"	#Pen
		xsetwacom --set 'GAOMON Gaomon Tablet Pad pad' Button 2 key "+ctrl +shift h -shift -ctrl"	#Highlighter
		xsetwacom --set 'GAOMON Gaomon Tablet Pad pad' Button 3 key "+ctrl z -ctrl"			        #Undo
		xsetwacom --set 'GAOMON Gaomon Tablet Pad pad' Button 8 key "+ctrl y -ctrl"			        #Redo	#Yes, Button 8 is correct

    #Pen - Settings these will mess with program defualt hand + eraser behaviour
        # xsetwacom --set 'GAOMON Gaomon Tablet Pen stylus' Button 1 "KEYBINDINGHERE"   #Pen Tip
        # xsetwacom --set 'GAOMON Gaomon Tablet Pen stylus' Button 2 "KEYBINDINGHERE"   #Lower Button
        # xsetwacom --set 'GAOMON Gaomon Tablet Pen stylus' Button 2 "KEYBINDINGHERE"   #Upper Button
}

function firewallReset
{
    ELEV=$(id | grep root | cut -d' ' -f1)
        if [ "$ELEV" == "uid=0(root)" ]; then
            echo -e "\nReseting all Firewall Rules (Default Accept + Flush Chains)"
            echo -e "Running as Root, commands will be run WITHOUT sudo"
                echo "Setting default policy to ALLOW"
                    iptables -P INPUT ACCEPT
                    iptables -P OUTPUT ACCEPT
                    iptables -P FORWARD ACCEPT

                echo "Flushing all chains"
                    iptables -F
        fi
        if [ "$ELEV" != "uid=0(root)" ]; then
            echo -e "\nReseting all Firewall Rules (Default Accept + Flush Chains)"
            echo -e "Running as standerd user, commands will be run with sudo"
                echo "Setting default policy to ALLOW"
                    sudo -i iptables -P INPUT ACCEPT
                    sudo -i iptables -P OUTPUT ACCEPT
                    sudo -i iptables -P FORWARD ACCEPT

                echo "Flushing all chains"
                    sudo -i iptables -F
        fi

}

function firewallServer
{
    echo -e "\nDeploying Server Firewall Rules"

    echo "Flushing all chains"
        sudo -i iptables -F

    #Change Policy to DROP at end of Server Ruleset. This prevents SSH session from freezing and needing to enter something to see output.

    echo "Allowing anything marked RELATED/ESTABLISHED"
        iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT incoming RELATED/ESTABLISHED"
        iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT outgoing RELATED/ESTABLISHED"

    echo "Allowing everything on loopback"
        iptables -A INPUT -s 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all incoming on loopback"
        iptables -A OUTPUT -d 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all outgoing on loopback"

    echo "Dropping anything marked INVALID"
        iptables -A INPUT -m conntrack --ctstate INVALID -j DROP -m comment --comment "REJECT anything marked INVALID"

    echo "Allowing ping"
        iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT incoming ping request"
        iptables -A OUTPUT -p icmp --icmp-type 0 -m state --state ESTABLISHED,RELATED -j ACCEPT -m comment --comment "ACCEPT outgoing ping reply"

    echo "Allowing services"
        echo " - ssh       (IN)"
            iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT incoming ssh"

        echo " - http      (IN)"
            iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT incoming http"

        echo " - https     (IN)"
            iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT incoming https"

        echo " - smtp      (OUT)"
            iptables -A OUTPUT -p tcp --dport 587 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT outgoing smtp"

        echo " - ntp       (OUT)"
            iptables -A OUTPUT -p udp --dport 123 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT outgoing ntp"

    echo "Allowing Network Access Group"
        iptables -A OUTPUT -m owner --gid-owner network-access -j ACCEPT -m comment --comment "ACCEPT outgoing Network Access Group"


    # echo "Allowing other boxes"
        # echo " - backup    (OUT)"
        # iptables -A OUTPUT -p tcp -d 0.0.0.0 --dport 22 -j ACCEPT -m comment --comment "ACCEPT outgoing backup (ssh)"

    echo "Limit SYN Flood"
        iptables -A INPUT -p tcp --syn -m limit --limit 5/s -j ACCEPT -m comment --comment "Limit SYN to 5/second"

    echo "Gracefully rejecting everything else"
        iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable -m comment --comment "Graceful UDP REJECTs"
        iptables -A INPUT -p tcp -j REJECT --reject-with tcp-rst -m comment --comment "Graceful TCP REJECTS"
        iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable -m comment --comment "Graceful UNKNOWN REJECTs"
    
    echo "Setting default policy to DROP"
        sudo -i iptables -P FORWARD DROP
        sudo -i iptables -P OUTPUT DROP
        sudo -i iptables -P INPUT DROP
}
function firewallWorkstation
{
    echo -e "\nDeploying Workstation Firewall Rules"

    echo "Flushing all chains"
        sudo -i iptables -F

    echo "Setting default policy to DROP"
        sudo -i iptables -P FORWARD DROP
        sudo -i iptables -P OUTPUT DROP
        sudo -i iptables -P INPUT DROP

    echo "Allowing anything marked RELATED/ESTABLISHED"
        sudo -i iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT incoming RELATED/ESTABLISHED"
        sudo -i iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT outgoing RELATED/ESTABLISHED"

    echo "Allowing everything on loopback"
        sudo -i iptables -A INPUT -s 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all incoming on loopback"
        sudo -i iptables -A OUTPUT -d 127.0.0.1 -j ACCEPT -m comment --comment "ACCEPT all outgoing on loopback"

    echo "Dropping anything marked INVALID"
        sudo -i iptables -A INPUT -m conntrack --ctstate INVALID -j DROP -m comment --comment "REJECT anything marked INVALID"

    echo "Allowing ping"
        sudo -i iptables -A OUTPUT -p icmp --icmp-type 0 -m state --state ESTABLISHED,RELATED -j ACCEPT -m comment --comment "ACCEPT outgoing ping reply"
    
    echo "Allowing services"
        echo " - SSH        (OUT)"
            sudo -i iptables -A OUTPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT outgoing ssh"
        echo " - HTTP       (OUT)"
            sudo -i iptables -A OUTPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT outgoing http"

        echo " - HTTPS      (OUT)"
            sudo -i iptables -A OUTPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT outgoing https"

        echo " - DNS        (OUT)"
            sudo -i iptables -A OUTPUT -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT outdoing dns"
        
        echo " - CUPS       (OUT)"
            sudo -i iptables -A OUTPUT -p tcp --dport 631 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT outdoing cups"
        
        echo " - Meet RTC   (OUT)"
            sudo -i iptables -A OUTPUT -p udp --dport 19302:19309 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT outdoing RTC to Google Meet"
        
        echo " - Dis. RTC   (OUT)"
            sudo -i iptables -A OUTPUT -p udp --dport 50000:50050 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT outdoing RTC to Discord"

        echo " - STUN RC    (OUT)"
            sudo -i iptables -A OUTPUT -p udp --dport 3478 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT outdoing STUN to RC Desktop"
}

function firewallSelect ()
{
    echo -e "What firewall ruleset do you want to deploy?"
    echo -e "\ts\tServer"
    echo -e "\tw\tWorkstation"
    echo -e "\tr\tReset (Flush Chains + Accept All)"

    read ANS
    
    #Server Filewall Rule Set
    if [ "$ANS" == "s" ]; then
        firewallServer
    fi

    #Workstation Filewall Rule Set
    if [ "$ANS" == "w" ]; then
        firewallWorkstation
    fi

    #Firewall Reset
    if [ "$ANS" == "r" ]; then
        firewallReset
    fi
}

function install ()
{
    echo -e "Run full install and setup script? (yes or n)"
    read ANS
    if [ "$ANS" == "yes" ]; then
        echo -e "\nstuff"
        #updates
        #sudo group
        #apt installation
        #graphics
        #appearance
        #dns
        #firewall
    fi
}

function startup ()
{
    monitors
    drawing
    firewallWorkstation
    updater
}

HELP=1
while getopts "umdsfi" FLAG; do
    case "$FLAG" in
        u)
            HELP=0
            updater
            ;;
        m)
            HELP=0
            monitors
            ;;
        d)
            HELP=0
            drawing
            ;;
        s)
            HELP=0
            startup
            ;;
        f)
            HELP=0
            firewallSelect
            ;;
        i)
            HELP=0
            install
            ;;
        *)
        #   echo -e "Usage: updater [OPTION]"
    esac
done

if [ $HELP -ne 0 ]; then
    echo -e "Usage: updater [OPTION]"
    echo -e "\t-u\tupdater\t\tUpdate from Multiple Package Managers"
    echo -e "\t-m\tmonitors\tSetup display link adapter and arrange monitors"
    echo -e "\t-d\tdrawing\t\tSetup drawing tablet"
    echo -e "\t-f\tfirewall\tDeploy firewall rules"
    echo -e "\t-s\tstartup\t\tRun Monitors, Drawing, Workstation Firewall"
    echo -e "\t-i\tinstall\t\tOverall Machine Setup"
fi