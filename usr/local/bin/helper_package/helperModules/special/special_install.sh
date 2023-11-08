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
                        curl                            # interact with urls
                        dnsutils                        # contains dig
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
                com.discordapp.Discord          # gamer chat
                com.github.tchx84.Flatseal      # flatseal, gui for flapak permissons
                com.system76.Popsicle           # easy iso flasher
                com.valvesoftware.Steam         # steam, games
                com.spotify.Client              # spotify, music
                com.visualstudio.code-oss       # IDE
                com.github.xournalpp.xournalpp  # pdf editor
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
                    apt install /tmp/packages/./mullvad.deb

            # signal
                echo -e "\n\n\e[45m install signal \e[49m\n\n"
                    wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
                    cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
                    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
                    sudo tee /etc/apt/sources.list.d/signal-xenial.list
                    sudo apt update && sudo apt install signal-desktop

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
        echo -e "\n\n\e[45m update dns servers \e[49m\n\n"
            echo -e '9.9.9.9\n1.1.1.1\n8.8.8.8' >> /etc/resolv.conf

    # static route 
        echo -e "\n\n\e[45m add static route \e[49m\n\n"
            nmcli connection modify "Wired connection 1" ipv4.routes "10.0.3.0/24 10.0.4.1"

    # updates
        echo -e "\n\n\e[45m run update module \e[49m\n\n"
            general_updater

    # nvidia drivers
        echo -e "\n\n\e[45m check if nvidia card is found \e[49m\n\n"
            NVIDIA_DETECT=$(nvidia-detect)
            NVIDIA_DETECT_DRIVER=$(nvidia-detect | grep nvidia-driver | cut -d ' ' -f5)
                if [ "$NVIDIA_DETECT" == "No NVIDIA GPU detected." ]; then
                    echo nvidia flag no
                elif [ "$NVIDIA_DETECT_DRIVER" == "nvidia-driver" ]; then
                    echo nvidia flag yes
                    #sleep 5
                    #nvidia-smi
                else
                    echo nvidia flag error
                fi

    # icons install + cache
    # keyboard shortcuts
    # startup applications
    # cron jobs


}

   #Clone GitHub Repo
        #git clone https://github.com/AdnanHodzic/displaylink-debian.git /tmp/displaylink-debian
        #./tmp/displaylink-debian/displaylink-debian.sh

    # Run xrandr --listproviders to view monitor outputs. Provider 0 should be GPU, 1-4 should be the adapters.
    # Should look like something below:
    # Provider 1: id: 0x138 cap: 0x2, Sink Output crtcs: 1 outputs: 1 associated providers: 0 name:modesetting
    # ...Goes to provider 4, looks like provider 1                                          ^ This 0 should change to 1 after the commands below
 # add contrib and non-free repos, change http to https, do this before steam and nvidia
# install nvidia-detect, grab what it wants you to install, do this uphere, before steam

    # setup unattended upgrades
    #    sudo dpkg-reconfigure --priority=low unattended-upgrades
    #    make choose yes
    #    check with "sudo systemctl status unattended-upgrades.service"


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