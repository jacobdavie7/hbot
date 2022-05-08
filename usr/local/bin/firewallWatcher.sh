#!/bin/bash

function firewallWatcher()
{
    if [ "$EVEVATE" == "root" ]; then
        while true; do
                clear
                iptables -L -v
                echo -e "\n\n\e[91mCTRL + C to Cancel\e[39m"
                    echo -e "\t\e[31mUse CTRL + Shift + Plus and CTRL + Minus to Zoom\e[39m"
                    echo -e "\t\e[31mRun 'iptables -Z' to Zero-out counters (rules stay intact)\e[39m"
                    echo -e "\t\e[31mNote that Fail2Ban rules will not load before refresh\e[39m"
                sleep 1
        done
    else
        while true; do
                clear
                sudo -i iptables -L -v
                echo -e "\n\n\e[91mCTRL + C to Cancel\e[39m"
                    echo -e "\t\e[31mUse CTRL + Shift + Plus and CTRL + Minus to Zoom\e[39m"
                    echo -e "\t\e[31mRun 'iptables -Z' to Zero-out counters (rules stay intact)\e[39m"
                    echo -e "\t\e[31mNote that Fail2Ban rules will not load before refresh\e[39m"
                sleep 1
        done
    fi
    #Two segments so we don't have to go though if statements every time
}

function firewallWatcherWATCHCOMMAND()
{
    if [ "$EVEVATE" == "root" ]; then
        watch -n 1 iptables -L -v
    else
        sudo -i watch -n 1 iptables -L -v
    fi
    #Two segments so we don't have to go though if statements every time
}