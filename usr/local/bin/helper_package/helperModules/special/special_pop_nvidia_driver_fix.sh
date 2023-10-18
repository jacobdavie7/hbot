#!/bin/bash

function special_pop_nvidia_driver_fix
{
    echo -e "\nRun pop os nvidia fixer script? Will Uninstall nvidia drivers (yes or n)"
    read ANS
    if [ "$ANS" != "yes" ]; then
        exit
    fi

    apt purge ~nnvidia
    apt autoremove
    apt clean

    apt update
    apt full-upgrade

    echo -e "\n\e[4mMonitors may not recognize input, but computer remains powered on. Give it a while to install, then force a restart with ACPI.\e[24m"
    echo -e "\n\e[4mConfirm message above and proceed with install? (y or N) \e[24m"
        read ANS
        if [ "$ANS" == "y" ]; then
            echo -e "\nContinuing\n\n\n"
            apt install system76-driver-nvidia
        else
            echo -e "\nexiting, no graphics drivers present. Can install with system76-driver-nvidia, nvidia-smi shows driver version. Debian can use nvidia-install and probally will install nvidia-driver"
        fi
}

# https://support.system76.com/articles/login-loop-pop/