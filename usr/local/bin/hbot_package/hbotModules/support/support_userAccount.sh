#!/bin/bash

function support_userAccount
{
    # Can't user $USER when run as root, this is still needed
    USER_ACCOUNT=$(cat /etc/passwd | grep "1000" | cut -d':' -f1)
    # USER_ACCOUNT=$(id -n -u)  # if run as root, will return root, not user account
}