#!/bin/bash

function install ()
{
    # checks
    if [ "$EVEVATE" == "root" ]; then
        echo -e "\n\e[44mDeploying Web Server Firewall Rules\e[49m"
    else
        echo -e "\n\e[91mPlease run as Root with 'su -l root'\e[39m\n"
        exit
    fi

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

                                                                          # .-------------------------------------------- terminal file explorer
                                                                          # |     .-------------------------------------- file sizes
                                                                          # |     |            .------------------------- display more languges
                                                                          # |     |            |              .---------- input Korean
                                                                          # |     |            |              |        .- draw ibus windows
                                                                          # |     |            |              |        |
        # apt                                                             # *     *            *              *        * 
            UTILITIES=( git tree htop dnsutils whois iptables curl ffmpeg ranger ncdu fonts-unfonts-core ibus-hangul zenity )
            for U in "${UTILITIES[@]}"
            do
                apt install -y $U
            done

            APPLICATIONS=( gparted qdirstat vlc keepassxc flameshot pulseeffects gimp kdenlive libreoffice libreoffice-gtk3 )
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