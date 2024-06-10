#!/bin/bash

function config_proxmox_unlock_stop
{

    echo -e "\n\e[44mExecuting Force unlock and stop\e[49m"

        echo -e "\n\e[95;4munlcok $1\e[39;24m"
            qm unlock $1

        echo -e "\n\e[95;4mremove var lock file for $1\e[39;24m"
            rm -f /var/lock/qemu-server/lock-$1.conf

        echo -e "\n\e[95;4mremove run lock file for $1\e[39;24m"
            rm -f /run/lock/qemu-server/lock-$1.conf

        echo -e "\n\e[95;4stop $1\e[39;24m"
            qm stop $1

        echo -e "\n\e[95;4check status $1\e[39;24m"
            qm status $1
}
