#!/bin/bash

function elevateCheck
{
    ELEVATE=$(id | grep root | cut -d' ' -f1)
        if [ "$ELEVATE" == "uid=0(root)" ]; then
            ELEVATE=root
        else
            ELEVATE=user
            echo -e "\nSorry, but this module needs elevated privileges. It looks like you are not root. Please run again with sudo.\n"
            exit
        fi
}