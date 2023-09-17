# Based off offical Debian upgrade script
# debian.org

#!/bin/bash


function special_debian_ver_upgrade
{
    POST=0
    echo -e "\n\e[44mUpdating Packages\e[49m"

    echo -e "\n\e[95;4mapt\e[39;24m"
        echo -e "\n\e[96mupdate\e[39m"
            apt update
        echo -e "\n\e[96mupgrade\e[39m"
            apt upgrade -y

    echo -e "\n\e[95;4mflatpak\e[39;24m"
        flatpak update -y
    
    echo -e "\n\e[95;4msnap\e[39;24m"
        snap refresh

    if [ "$POST" == "1" ]; then
        echo -e "\n\e[44mCongrats, you are now running Debian $$NEW_VER\e[49m"
        echo -e "\n\e[44mYou should probally restart now\e[49m"
        exit 0;
    fi

    echo -e "\n\e[44mVersions\e[49m"

echo -e "\n\e[4mCurrent Verison Codename? Note Capitalization\e[24m"
    read CURRENT_VER

echo -e "\n\e[4mNew Verison Codename? Note Capitalization\e[24m"
    read NEW_VER

echo -e "\nOkay, Update \e[43m$CURRENT_VER\e[0m to \e[43m$NEW_VER\e[0m"
echo -e "Is this correct, including Capitalization? (y or N)"
read ANS

if [ "$ANS" != "y" ]; then
        echo -e "Phew, crisis averted! Exiting. Enjoy $CURRENT_VER\n"
        exit 1
fi

echo -e "\n Okay, will upgrade $CURRENT_VER to $NEW_VER"

# upgrade
    upgrade

# change-repos
    echo -e "\n\e[44mChangining Repos\e[49m"
        sed "s/$CURRENT_VER/$NEW_VER/g" /etc/apt/sources.list
    echo -e "\n\e[44mVerify the sources.list file below is correct\e[49m\n\n\n"
        cat /etc/apt/sources.list

    echo -e "\n\e[44mDoes it look correct?\e[49m"
        read ANS
        if [ "$ANS" != "y" ]; then
            echo -e "\n Uh, oh! You better go back and fix your /etc/apt/sources.list file. Exiting."
            exit 1
        fi

        echo -e "\n Great! Continuing"

# prep-repos
    echo -e "\n\e[44mClean(delete apt cache)\e[49m"
        apt clean
    echo -e "\n\e[44mupdate repos with $CURRENT_VER\e[49m"
        apt update

# upgrade
    echo -e "\n\e[44mUPGRADING - DO NOT INTERRUPT\e[49m"
        apt full-upgrade

# cleanup
    echo -e "\n\e[44mRemoving unused dependecies (autoremove)\e[49m"
        apt autoremove

# set post flag and update
    POST=1
    upgrade
}

