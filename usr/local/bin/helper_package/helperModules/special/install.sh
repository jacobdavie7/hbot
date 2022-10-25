#!/bin/bash

function install
{
    echo -e "\nRun full install and setup script? (yes or n)"
    read ANS
    if [ "$ANS" != "yes" ]; then
        exit
    fi

    # read in info
    echo -e "\n\e[4mWhat is your user account name?\e[39;24m"
    read USER_ACCOUNT_NAME

    echo -e "\nUpdate sources.list file"
        echo -e 'deb https://repo.ialab.dsu.edu/debian/ bullseye main contrib non-free \ndeb-src https://repo.ialab.dsu.edu/debian/ bullseye main contrib non-free \n\ndeb https://security.debian.org/debian-security bullseye-security main contrib non-free \ndeb-src https://security.debian.org/debian-security bullseye-security main contrib non-free \n\ndeb https://repo.ialab.dsu.edu/debian/ bullseye-updates main contrib non-free \ndeb-src https://repo.ialab.dsu.edu/debian/ bullseye-updates main contrib non-free' >> /etc/apt/sources.list
    # updates
    echo -e "\nRunning Updates"
        echo " - update"
            apt update
        echo " - upgrade"
            apt upgrade
        echo " - autoremove"
            apt autoremove

   # sudo 
    echo -e "\nSudo Group"
        echo " - installing sudo"
            apt install sudo
        echo " - Adding $USER_ACCOUNT_NAME to the sudo group"
            usermod -a -G sudo $USER_ACCOUNT_NAME
    
    # install packages
    echo -e "\n Install apt Packages\n"

        # apt            # package usage listed below
            UTILITIES=( git tree htop dnsutils whois iptables curl ffmpeg ranger ncdu gzip unzip fonts-unfonts-core ibus-hangul zenity iptables-persistent network-manager-gnome )
            for U in "${UTILITIES[@]}"
            do
                apt install -y $U
            done

            APPLICATIONS=( gparted qdirstat vlc keepassxc flameshot pulseeffects gimp kdenlive libreoffice libreoffice-gtk3 galculator speedcrunch steghide )
            for A in "${APPLICATIONS[@]}"
            do
                apt install -y $A
            done

            PACKAGE_MANAGERS=( flatpak snapd )
            for P in "${PACKAGE_MANAGERS[@]}"
            do
                apt install -y $P
            done

            FUN=( cmatrix hollywood neofetch )
            for F in "${FUN[@]}"
            do
                apt install -y $F
            done

        # flatpak
            # add flathub repo
                flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

            FLATPAK=( org.mozilla.firefox com.spotify.Client com.discordapp.Discord com.slack.Slack com.visualstudio.code com.github.xournalpp.xournalpp com.valvesoftware.Steam com.obsproject.Studio )
            for F in "${FLATPAK[@]}"
            do
                flatpak install flathub $F
            done

        # snap
            SNAP=( cpufetch )
            for S in "${SNAP[@]}"
            do
                snap install $S
            done

    # update DNS servers
        echo -e '9.9.9.9\n1.1.1.1\n8.8.8.8' >> /etc/resolv.conf

    # setup firewall
        firewallHome
}


   #Clone GitHub Repo
        #git clone https://github.com/AdnanHodzic/displaylink-debian.git /tmp/displaylink-debian
        #./tmp/displaylink-debian/displaylink-debian.sh

    # Run xrandr --listproviders to view monitor outputs. Provider 0 should be GPU, 1-4 should be the adapters.
    # Should look like something below:
    # Provider 1: id: 0x138 cap: 0x2, Sink Output crtcs: 1 outputs: 1 associated providers: 0 name:modesetting
    # ...Goes to provider 4, looks like provider 1                                          ^ This 0 should change to 1 after the commands below



# ranger                terminal file explorer
# ncdu                  file sizes
# fonts-unfonts-core    display more lanuages
# ibus-hangul           input korean
# zenity                draw windows for ibus
# galculator            simple calculator
# speedcrunch           advanced calculator
# libreoffice-gtk3      make libreoffice look better
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#