#!/bin/bash

function support_userAccount
{
    USER_ACCOUNT=$(cat /etc/passwd | grep "1000" | cut -d':' -f1)
    # USER_ACCOUNT=$(id -n -u)  # if run as root, will return root, not user account
}