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

# add contrib and non-free repos, change http to https, do this before steam and nvidia
# install nvidia-detect, grab what it wants you to install, do this uphere, before steam


    # install packages

        # apt            # package usage listed below
            echo -e "\n Install APT Packages\n"
                UTILITIES=(
                    curl                            # interact with urls
                    dnsutils                        # contains dig
                    ffmpeg                          # video converter/media formats
                    git                             # content tracker
                    gzip                            # gzip compression
                    hdparm                          # get drive parameters
                    htop                            # proccess viewer
                    iptables                        # firewall
                    iptables-persistent             # make ruleset persistent upon restart
                    lshw                            # list hardware, view cpu details
                    ncdu                            # file sizes
                    network-manager-gnome           # panel applet
                    ranger                          # terminal file explorer
                    software-properties-common      # repo manager
                    sudo                            # super
                    tree                            # show directory structure
                    unzip                           # unzip files
                    vim                             # text editor
                    whois                           # make whois lookups
                    zip                             # create zip files
                )
                for U in "${UTILITIES[@]}"
                do
                    apt install -y $U
                done

                APPLICATIONS=(
                    gnome-disk-utility              # gui disk manager
                    gparted                         # gui partition manager
                    keepassxc                       # password manager
                    qdirstat                        # visualize storage
                    screen                          # screen manager with terminal emulation
                    vlc                             # media player
                )
                for A in "${APPLICATIONS[@]}"
                do
                    apt install -y $A
                done

                PACKAGE_MANAGERS=(
                    flatpak
                #    snapd
                )
                for P in "${PACKAGE_MANAGERS[@]}"
                do
                    apt install -y $P
                done

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

                EXTRA=(
                    fonts-unfonts-core              # display more lanuages
                    ibus-hangul                     # input korean
                    libpcslite-dev                  # smartcard access via pc/sc (proxmark)
                    libreadline-dev                 # consistent ui to recall lines of previously input (proxmark)
                    menulibre                       # edit applications whisker menu can open (add app images)
                    ntp                             # get time from ntp server
                    v4l2loopback-dkms               # video loopback device - needed for obs
                    zenity                          # draw windows for ibus
                    flameshot                       # screenshots
                    firefox-esr                     # web browser
                    galculator                      # simple calculator
                    gqrx-sdr                        # sdr
                    libreoffice                     # productivity suite
                    libreoffice-gtk3                # make libreoffice look better
                    obs-studio                      # screencast
                    pulseeffects                    # effects
                    steam                           # games     #non-free repo
                    thunderbird                     # email client
                    wireshark                       # analyze packets and network traffic
                    gummi                           # laTeX editor
                    speedcrunch                     # advanced calculator
                )
                for E in "${EXTRA[@]}"
                do
                    apt install -y $E
                done


        # flatpak
            echo -e "\n Install FLATPAK Packages\n"

                # add flathub repo
                    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

                FLATPAK=(
                    com.github.xournalpp.xournalpp  # xournalpp, pdf editor
                    com.github.tchx84.Flatseal      # flatseal, gui for flapak permissons
                    com.spotify.Client              # spotify, music
                    com.valvesoftware.Steam         # steam, games
                    com.visualstudio.code-oss       # IDE
                    com.github.wwmm.easyeffects     # sound proccesing for pipewire
                    )
                for F in "${FLATPAK[@]}"
                do
                    flatpak install flathub $F
                done

        # local
            echo -e "\n Install LOCAL APT Packages\n"
            
            # mullvad
                mkdir /tmp/packages
                chmod 170 /tmp/packages
                chown _apt:jacob /tmp/packages
                wget -O /tmp/packages/mullvad.deb https://mullvad.net/en/download/app/deb/latest -P /tmp/packages # -O used to put into file, page does not give .deb file
                apt install /tmp/packages/./mullvad.deb
                
            # virtual box
            

    # setup unattended upgrades
        sudo dpkg-reconfigure --priority=low unattended-upgrades
        # make choose yes
        # check with "sudo systemctl status unattended-upgrades.service"

    # sudo 
        echo -e "\n Sudo Group"
                USER_ACCOUNT_NAME=$(id -n -u)
            echo " - installing sudo"
                apt install sudo
            echo " - Adding $USER_ACCOUNT_NAME to the sudo group"
                usermod -a -G sudo $USER_ACCOUNT_NAME


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