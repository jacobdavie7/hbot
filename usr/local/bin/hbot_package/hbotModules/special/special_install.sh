#!/bin/bash

function special_install
{
    # check if we want to run script
        echo -e "\nRun full install and setup script? (yes or n)"
        read ANS
        if [ "$ANS" != "yes" ]; then
            exit
        fi

    # sources.list config
        echo -e "\n\n\e[45m change apt sources.list to use https \e[49m\n\n"
            sed -i 's/http:/https:/g' /etc/apt/sources.list

        echo -e "\n\n\e[45m add contrib and non-free repos to apt sources.list \e[49m\n\n"
            sed -i '/^deb / s/$/ contrib non-free/' /etc/apt/sources.list
            sed -i '/^deb-src / s/$/ contrib non-free/' /etc/apt/sources.list
        echo -e "\n\n\e[45m update apt to use new sources.list changes \e[49m\n\n"
            apt update

    # updates
        echo -e "\n\n\e[45m run update module \e[49m\n\n"
            general_updater

    # package installation
        # apt
            # apt utilities
                echo -e "\n\n\e[45m install utility apt packages \e[49m\n\n"
                    UTILITIES=(
                        autorandr                       # default display layout
                        btop                            # better proccess viewer
                        curl                            # interact with urls
                        dnsutils                        # contains dig
                        fail2ban                        # ssh rate limiting
                        ffmpeg                          # video converter/media formats
                        fonts-unfonts-core              # display more lanuages
                        git                             # content tracker
                        gzip                            # gzip compression
                        hdparm                          # get drive parameters
                        htop                            # proccess viewer
                        ibus-hangul                     # input korean
                        iptables                        # firewall
                        iptables-persistent             # make ruleset persistent upon restart         
                        lm-sensors                      # sensor command to view temps
                        lshw                            # list hardware, view cpu details
                        menulibre                       # edit applications whisker menu can open (add app images)
                        ncdu                            # file sizes
                        network-manager-gnome           # panel applet
                        ntp                             # get time from ntp server
                        nvidia-detect                   # detect package for nvidia drivers (probally going to be nvidia-driver)
                        pipewire-alsa                   # configures pipewire to use alsa plugin
                        pipewire-media-session-         # needed for pipewire
                        pipewire-pulse                  # pipewire replacment daemon for pulse
                        ranger                          # terminal file explorer
                        screen                          # screen manager with terminal emulation
                        secure-delete                   # contains sfill command
                        software-properties-common      # repo manager
                        sudo                            # super
                        tree                            # show directory structure
                        unattended-upgrades             # keep apt upgraded
                        unzip                           # unzip files
                        vim                             # text editor
                        whois                           # make whois lookups
                        wireplumber                     # pipewire session manager
                        zenity                          # draw windows for ibus
                        zip                             # create zip files
                    )
                    for U in "${UTILITIES[@]}"
                    do
                        apt install -y $U
                    done

            # apt applications
                echo -e "\n\n\e[45m install application apt packages \e[49m\n\n"
                    APPLICATIONS=(
                        chromium                        # alt web browser, chromium-browser on pop
                        easyeffects                     # audio effects for pipewire
                        firefox-esr                     # web browser
                        galculator                      # simple calculator
                        gnome-disk-utility              # gui disk manager
                        gparted                         # gui partition manager
                        gsmartcontrol                   # gui for smart data
                        keepassxc                       # password manager
                        libreoffice                     # productivity suite
                        libreoffice-gtk3                # make libreoffice look better 
                        pavucontrol                     # audio mixer, made for pulse, but works with pipewire
                        qdirstat                        # visualize storage
                        vlc                             # media player
                    )
                    for A in "${APPLICATIONS[@]}"
                    do
                        apt install -y $A
                    done

            # package managers from apt
                echo -e "\n\n\e[45m install package managers from apt \e[49m\n\n"
                    PACKAGE_MANAGERS=(
                        flatpak
                    )
                    for P in "${PACKAGE_MANAGERS[@]}"
                    do
                        apt install -y $P
                    done

            # apt fun
                echo -e "\n\n\e[45m install fun apt packages \e[49m\n\n"
                    FUN=(
                        cmatrix                         # enter the matrix
                        cowsay                          # what does the cow say
                        fortune                         # random (or not???) message
                        hollywood                       # l337 h@x
                        lolcat                          # love is love
                        neofetch                        # i run arch btw
                        rig                             # generate random fake id
                    )
                    for F in "${FUN[@]}"
                    do
                        apt install -y $F
                    done

        # flatpak
            echo -e "\n\n\e[45m install flatpak packages \e[49m\n\n"

            # add flathub repo
                flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

            FLATPAK=(
                org.cryptomator.Cryptomator     # cryptomator   # client side encryption
                com.visualstudio.code-oss       # code-oss      # IDE; vscode without microsoft temlemetry, vscodium is 'better' built before micosoft but have had endless problems with git. Code-oss works much better
                com.discordapp.Discord          # discord       # gamer chat
                com.github.tchx84.Flatseal      # flatseal      # gui for flapak permissons
                org.kde.kdenlive                # kdenlive      # video editor  # is in apt repos, but installs a ton of kde bloat like kde connect for phone. Flathub stops crap from being downloaded and is actually smaller than apt repos, plus don't have to deal with bloat
                com.system76.Popsicle           # popsicle      # easy iso flasher
                com.spotify.Client              # spotify       # music
                com.github.xournalpp.xournalpp  # xournalpp     # pdf editor
                )
            for F in "${FLATPAK[@]}"
            do
                flatpak install flathub $F -y
            done

        # apt local packages
            echo -e "\n\n\e[45m install local apt packages \e[49m\n\n"

            # mullvad
                echo -e "\n\n\e[45m install mullvad \e[49m\n\n"
                    mkdir /tmp/packages
                    chmod 170 /tmp/packages
                    chown _apt:jacob /tmp/packages
                    wget -O /tmp/packages/mullvad.deb https://mullvad.net/en/download/app/deb/latest -P /tmp/packages # -O used to put into file, page does not give .deb file
                    apt install -y /tmp/packages/./mullvad.deb
                    rm -r /tmp/packages

            # signal
                echo -e "\n\n\e[45m install signal \e[49m\n\n"
                    wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
                    cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
                    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
                    sudo tee /etc/apt/sources.list.d/signal-xenial.list
                    sudo apt update && sudo apt install -y signal-desktop

            # steam     # this is the best way to install steam
                echo -e "\n\n\e[45m install Steam \e[49m\n\n"
                    mkdir /tmp/packages
                    chmod 170 /tmp/packages
                    chown _apt:jacob /tmp/packages
                    wget -O /tmp/packages/steam_latest.deb https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb -P /tmp/packages # -O used to put into file, page does not give .deb file
                    apt install -y /tmp/packages/./steam_latest.deb
                    rm -r /tmp/packages

            # virtual box - ensure distro and virtual box version are correct (distro (bookmark) in 1st line, virtualbox version in last. Versions do no perfectly match downloadable on website, tab complete to check what the latest version in the repo is)
                echo -e "\n\n\e[45m install virtualbox \e[49m\n\n"
                    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian bookworm contrib' |\
                    sudo tee /etc/apt/sources.list.d/oracle-virtualbox.list
                    wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
                    sudo apt update && sudo apt install virtualbox-7.0 -y

    # setup firewall
        echo -e "\n\n\e[45m call firewall home module \e[49m\n\n"
            firewall_home

    # sudo 
        echo -e "\n\n\e[45m add user account to sudo group \e[49m\n\n"
            usermod -a -G sudo $USER_ACCOUNT

    # enable wireplumber session manger for pipewire
        echo -e "\n\n\e[45m enable wireplumber service \e[49m\n\n"
            systemctl --user --now enable wireplumber.service

    # update DNS servers
    #    echo -e "\n\n\e[45m update dns servers \e[49m\n\n"
    #        echo -e '9.9.9.9\n1.1.1.1\n8.8.8.8' >> /etc/resolv.conf

    # static route 
        echo -e "\n\n\e[45m add static route \e[49m\n\n"
            nmcli connection modify "Wired connection 1" +ipv4.routes "10.0.0.0/8 10.0.40.1"
        
        echo -e "\n\n\e[45m Restart networking, network manager, disable and re-enable \e[49m\n\n"
            systemctl restart networking
                sleep 1
            systemctl restart NetworkManager
                sleep 1
            nmcli networking off
                sleep 2
            nmcli networking on
                sleep 15

    # setup fail2ban
        echo -e "\n\n\e[45m setup fail2ban \e[49m\n\n"
            cp /etc/fail2ban/fail2ban.conf  /etc/fail2ban/fail2ban.local                        # create fail2ban.local file
            cp /etc/fail2ban/jail.conf  /etc/fail2ban/jail.local                                # create jail.local file
            echo -e "[sshd]\nenabled=true" | sudo tee /etc/fail2ban/jail.local                  # setup sshd for debian
            echo -e "[sshd]\nbackend=systemd\nenabled=true" | sudo tee /etc/fail2ban/jail.local # setup sshd for debian

    # setup autorandr for default dispaly order
        echo -e "\n\n\e[45m setup autorandr \e[49m\n\n"
            config_monitors                     # call the monitors function, autorandr will save the current settings and layout
            autorandr --save triple_primary     # save the currently display layout and settings as a autorandr profile called triple_primary
            autorandr --default triple_primary  # set the triple_primary profile as the default
            # run "autorandr triple_primary" to set profile to triple_primary, "autorandr --config" to view saved config of current profile

    # update timeout from 90s to 5s. This will only give nvidia-persisted 5s before being killed during shutdown, instead of needing to wait the full 90s.
        echo -e "\n\n\e[45m update stop timeout \e[49m\n\n"
            sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=5s/' /etc/systemd/system.conf
    
    
    # updates
        echo -e "\n\n\e[45m add weekly cronjob to remove files deleted from gui \e[49m\n\n"
            echo "0 0 * * 0 $USER_ACCOUNT rm -rf /home/$USER_ACCOUNT/.local/share/Trash/*" | sudo tee -a /etc/crontab
        
    # updates
        echo -e "\n\n\e[45m run update module \e[49m\n\n"
            general_updater

    # nvidia drivers
        echo -e "\n\n\e[45m check if nvidia card is found \e[49m\n\n"
            NVIDIA_DETECT=$(nvidia-detect)
            NVIDIA_DETECT_DRIVER=$(nvidia-detect | grep nvidia-driver | cut -d ' ' -f5)
                if [ "$NVIDIA_DETECT" == "No NVIDIA GPU detected." ]; then
                    echo -e "\n\n no nvidia GPU found \n\n"
                elif [ "$NVIDIA_DETECT_DRIVER" == "nvidia-driver" ]; then
                    echo -e "\n\n nvidia GPU found! Installing nvidia-driver \n\n"   # keep space between ! and \n
                    apt install nvidia-driver -y
                    sleep 5
                    nvidia-smi
                else
                    echo -e "\n\n error detecting if nvidia GPU is present. No action will be taken \n\n"
                fi

    # icons install + cache
    # keyboard shortcuts
    # startup applications
    # cron jobs
    # setup unattended upgrades
    #    sudo dpkg-reconfigure --priority=low unattended-upgrades
    #    make choose yes
    #    check with "sudo systemctl status unattended-upgrades.service"

}



# apt extra
#   echo -e "\n\n\e[45m install extra apt packages \e[49m\n\n"
#      EXTRA=(
#      libpcslite-dev                  # smartcard access via pc/sc (proxmark)
#      libreadline-dev                 # consistent ui to recall lines of previously input (proxmark)
#      v4l2loopback-dkms               # video loopback device - needed for obs
#      gqrx-sdr                        # sdr
#      obs-studio                      # screencast
#      pulseeffects                    # effects for pulse
#      steam                           # games     #contrib repo      # flatpak more stable
#      thunderbird                     # email client
#      wireshark                       # analyze packets and network traffic
#      gummi                           # laTeX editor
#      speedcrunch                     # advanced calculator
#      )
#      for E in "${EXTRA[@]}"
#      do
#          apt install -y $E
#      done

# flatpak extra
#   echo -e "\n\n\e[45m install extra apt packages \e[49m\n\n"
#      FLATPAK=(
#           com.jgraph.drawio.desktop
#           com.visualstudio.code-oss       # IDE
#      )
#      for F in "${FLATPAK[@]}"
#      do
#           flatpak install flathub $F -y
#      done
