#!/bin/bash

function special_install
{
    echo -e "\nRun full install and setup script? (yes or n)"
    read ANS
    if [ "$ANS" != "yes" ]; then
        exit
    fi

    # updates
        general_updater

# add contrib and non-free repos, change http to https, do this before steam and nvidia
# install nvidia-detect, grab what it wants you to install, do this uphere, before steam

    # install packages

        # apt            # package usage listed below
            echo -e "\n Install APT Packages\n"
                UTILITIES=(
                    curl                            # interact with urls
                    dnsutils                        # contains dig
                    etherwake                       # send magic packets
                    ethtool                         # view nic info
                    ffmpeg                          # video converter/media formats
                    fonts-unfonts-core              # display more lanuages
                    git                             # content tracker
                    gzip                            # gzip compression
                    hdparm                          # get drive parameters
                    htop                            # proccess viewer
                    ibus-hangul                     # input korean
                    iptables                        # firewall
                    iptables-persistent             # make ruleset persistent upon restart
                    libc++1                         # keep discord from crashing
                    libc++1-14                      # keep discord from crashing
                    libc++abi1-14                   # keep discord from crashing
                    libpcslite-dev                  # smartcard access via pc/sc (proxmark)
                    libreadline-dev                 # consistent ui to recall lines of previously input (proxmark)
                    libunwind-14                    # keep discord from crashing
                    lshw                            # list hardware, view cpu details
                    menulibre                       # edit applications whisker menu can open (add app images)
                    ncdu                            # file sizes
                    network-manager-gnome           # panel applet
                    ntp                             # get time from ntp server
                    ranger                          # terminal file explorer
                    software-properties-common      # repo manager
                    sudo                            # super
                    tree                            # show directory structure
                    unzip                           # unzip files
                    v4l2loopback-dkms               # video loopback device - needed for obs
                    vim                             # text editor
                    whois                           # make whois lookups
                    zenity                          # draw windows for ibus
                    zip                             # create zip files
                )
                for U in "${UTILITIES[@]}"
                do
                    apt install -y $U
                done

                APPLICATIONS=(
                    firefox-esr                     # web browser
                    flameshot                       # screenshots
                    galculator                      # simple calculator
                    gnome-disk-utility              # gui disk manager
                    gparted                         # gui partition manager
                    gqrx-sdr                        # sdr
                    gummi                           # laTeX editor
                    keepassxc                       # password manager
                    libreoffice                     # productivity suite
                    libreoffice-gtk3                # make libreoffice look better
                    obs-studio                      # screencast
                    pulseeffects                    # effects
                    qdirstat                        # visualize storage
                    screen                          # screen manager with terminal emulation
                    speedcrunch                     # advanced calculator
                    steam                           # games     #non-free repo
                    thunderbird                     # email client
                    vlc                             # media player
                    wireshark                       # analyze packets and network traffic
                    xournalpp                       # pdf editing
                )
                for A in "${APPLICATIONS[@]}"
                do
                    apt install -y $A
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

        # local
            echo -e "\n Install LOCAL APT Packages\n"

            # discord
                wget -O /tmp/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb" # -O used to put into file, page does not give .deb file
                apt install /tmp/./discord.deb
            
            # visual studio
                wget -O /tmp/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" # -O used to put into file, page does not give .deb file
                apt install /tmp/./vscode.deb
                
            # spotify
                curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
                echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
                sudo apt-get update && sudo apt install spotify-client

            # mullvad
                wget -O /tmp/mullvadVPN.deb "https://mullvad.net/en/download/app/deb/latest" # -O used to put into file, page does not give .deb file
                apt install /tmp/./mullvadVPN.deb
            
            # virtual box
                # do this manually, no link to latest, just specific verisons

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
        timedatectl set-ntp true

    # setup firewall
        firewallHome

    # static route
        nmcli connection modify "Wired Connection 1" ipv4.routes "10.0.3.0/24 10.0.4.1"
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

