#!/bin/bash

function userAccount
{
    USER_ACCOUNT=$(cat /etc/passwd | grep "1000" | cut -d':' -f1)
}