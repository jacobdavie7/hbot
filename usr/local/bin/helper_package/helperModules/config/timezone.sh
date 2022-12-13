#!/bin/bash

function timezoneNote
{
    echo -e "\nTimezone TEMPORARILY updated. Will be RESET upon restart.\n"
}

function timezonePacific
{
    timedatectl set-timezone America/Los_Angeles
    timezoneNote
}

function timezoneMountain
{
    timedatectl set-timezone America/Denver
    timezoneNote
}

function timezoneCentral
{
    timedatectl set-timezone America/Chicago
    timezoneNote
}

function timezoneEastern
{
    timedatectl set-timezone America/New_York
    timezoneNote
}

function timezoneArizona
{
    timedatectl set-timezone America/Phoenix
    timezoneNote
}

function timezoneKorea
{
    timedatectl set-timezone Asia/Seoul
    timezoneNote
}

function timezoneAuto
{
    systemctl enable geoclue.service
    systemctl start geoclue.service
    timedatectl set-timezone GeoClue
}