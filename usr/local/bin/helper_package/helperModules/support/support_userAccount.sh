#!/bin/bash

function support_userAccount
{
    USER_ACCOUNT=$(id -n -u)
    # USER_ACCOUNT=$(cat /etc/passwd | grep "1000" | cut -d':' -f1)
}