#!/bin/bash

function install
{
    echo -e "\nRun full install and setup script? (yes or n)"
    read ANS
    if [ "$ANS" != "yes" ]; then
        exit
    fi

    # updates
        updater

    # sudo 
        echo -e "\n Sudo Group"
                USER_ACCOUNT_NAME=$(id -n -u)
            echo " - installing sudo"
                apt install sudo
            echo " - Adding $USER_ACCOUNT_NAME to the sudo group"
                usermod -a -G sudo $USER_ACCOUNT_NAME
    
    # install packages

        # apt            # package usage listed below
            echo -e "\n Install APT Packages\n"
                UTILITIES=(
                    curl                            #
                    dnsutils                        # contains dig
                    ffmpeg                          # 
                    fonts-unfonts-core              # display more lanuages
                    git                             #
                    gzip                            #
                    hdparm                          #
                    htop                            #   
                    ibus-hangul                     # input korean
                    iptables                        #
                    iptables-persistent             #
                    libpcslite-dev                  # smartcard access via pc/sc (proxmark)
                    libreadline-dev                 # consistent ui to recall lines of previously input (proxmark)
                    lshw                            # list hardware, view cpu details
                    menulibre                       # edit applications whisker menu can open (add app images)
                    ncdu                            # file sizes
                    network-manager-gnome           # panel applet
                    ntp                             #
                    ranger                          # terminal file explorer
                    software-properties-common      #
                    tree                            #
                    unzip                           #
                    v4l2loopback-dkms               # video loopback device - needed for obs
                    vim                             #
                    whois                           #
                    zenity                          # draw windows for ibus
                    zip                             #
                )
                for U in "${UTILITIES[@]}"
                do
                    apt install -y $U
                done

                APPLICATIONS=(
                    firefox-esr                     #
                    flameshot                       #
                    galculator                      # simple calculator
                    gnome-disk-utility
                    gparted                         #
                    gqrx-sdr                        # sdr
                    keepassxc                       #
                    libreoffice                     #
                    libreoffice-gtk3                # make libreoffice look better
                    obs-studio                      #
                    pulseeffects                    #
                    qdirstat                        #
                    screen                          #
                    speedcrunch                     # advanced calculator
                    steghide                        #
                    thunderbird                     #
                    vlc                             #
                    wireshark                       #
                )
                for A in "${APPLICATIONS[@]}"
                do
                    apt install -y $A
                done

                PACKAGE_MANAGERS=(
                    flatpak                         #
                    snapd                           #
                )
                for P in "${PACKAGE_MANAGERS[@]}"
                do
                    apt install -y $P
                done

                FUN=(
                    cmatrix                         #
                    cowsay                          #
                    fortune                         #
                    hollywood                       # l337 h@x
                    lolcat                          #
                    neofetch                        #
                    rig                             # generate random fake id
                )
                for F in "${FUN[@]}"
                do
                    apt install -y $F
                done

        # flatpak
            echo -e "\n Install FLATPAK Packages\n"

                # add flathub repo
                    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

                FLATPAK=( com.github.xournalpp.xournalpp )
                for F in "${FLATPAK[@]}"
                do
                    flatpak install flathub $F
                done

        # snap
            echo -e "\n Install SNAP Packages\n"

            SNAP=( slack )
            for S in "${SNAP[@]}"
            do
                snap install $S
            done

        # local
            echo -e "\n Install LOCAL APT Packages\n"

            # steam
                wget https://cdn.akamai.steamstatic.com/client/installer/steam.deb -P /tmp/packages
                apt install /tmp/packages/./steam.deb

            # discord
                wget -O /tmp/packages/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb" # -O used to put into file, page does not give .deb file
                apt install /tmp/packages/./discord.deb

            # slack
            #    wget https://downloads.slack-edge.com/releases/linux/4.28.184/prod/x64/slack-desktop-4.28.184-amd64.deb -P /tmp/packages
            #    apt install /tmp/packages/./slack-desktop-4.28.184-amd64.deb
            #    echo "deb https://packagecloud.io/slacktechnologies/slack/debian/ jessie main" | sudo tee /etc/apt/sources.list.d/slack.list
            #    /etc/cron.daily/./slack
            #    apt upgrade -y
            #    apt autoremove -y
            
            # visual studio
                wget -O /tmp/packages/vscode.deb https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64 -P /tmp/packages # -O used to put into file, page does not give .deb file
                apt install /tmp/packages/./vscode.deb

            # spotify
                curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
                echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
                sudo apt-get update && sudo apt-get install spotify-client

            # mullvad
            # virtual box
            # tor
            # xournalpp
            

    # setup unattended upgrades
        sudo dpkg-reconfigure --priority=low unattended-upgrades
        # make choose yes
        # check with "sudo systemctl status unattended-upgrades.service"

    # update DNS servers
        echo -e "\n Update DNS Servers\n"

            echo -e '9.9.9.9\n1.1.1.1\n8.8.8.8' >> /etc/resolv.conf

    # ntp
        systemctl start ntp
        systemctl enable ntp

    # setup firewall
        firewallHome

    # set hostname
        
    # from drawing module, put this here so don't need sudo.    
        #Append 70-wacom.conf
        XORG_APPEND=$(cat /usr/share/X11/xorg.conf.d/70-wacom.conf | grep "S620" | cut -d' ' -f2,3 | sed 's/ //g')
            if [ "$XORG_APPEND" != "GaomonS620" ]; then
                chmod 664 /usr/share/X11/xorg.conf.d/70-wacom.conf #Requires root
                echo -e '\n\n# Gaomon S620\nSection "InputClass"\n\tIdentifier "GAOMON Gaomon Tablet"\n\tMatchUSBID  "256c:006d"\n\tMatchDevicePath "/dev/input/event*"\n\tDriver "wacom"\nEndSection' >> /usr/share/X11/xorg.conf.d/70-wacom.conf
                chmod 644 /usr/share/X11/xorg.conf.d/70-wacom.conf #Requires root
                echo -e "Need to Restart/Logout Before Continuing. Do so and Run Script Again"
                exit
            else
                echo -e "\nEntry in config found!"
            fi




}


   #Clone GitHub Repo
        #git clone https://github.com/AdnanHodzic/displaylink-debian.git /tmp/displaylink-debian
        #./tmp/displaylink-debian/displaylink-debian.sh

    # Run xrandr --listproviders to view monitor outputs. Provider 0 should be GPU, 1-4 should be the adapters.
    # Should look like something below:
    # Provider 1: id: 0x138 cap: 0x2, Sink Output crtcs: 1 outputs: 1 associated providers: 0 name:modesetting
    # ...Goes to provider 4, looks like provider 1                                          ^ This 0 should change to 1 after the commands below

