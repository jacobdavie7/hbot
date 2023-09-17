#!/bin/bash

function config_timezoneNote
{
    echo -e "\nTimezone updated.\n"
}

function config_timezonePacific
{
    timedatectl set-timezone America/Los_Angeles
    config_timezoneNote
}

function config_timezoneMountain
{
    timedatectl set-timezone America/Denver
    config_timezoneNote
}

function config_timezoneCentral
{
    timedatectl set-timezone America/Chicago
    config_timezoneNote
}

function config_timezoneEastern
{
    timedatectl set-timezone America/New_York
    config_timezoneNote
}

function config_timezoneArizona
{
    timedatectl set-timezone America/Phoenix
    config_timezoneNote
}

function config_timezoneKorea
{
    timedatectl set-timezone Asia/Seoul
    config_timezoneNote
}

function config_timezoneAuto
{
    systemctl enable geoclue.service
    systemctl start geoclue.service
    timedatectl set-timezone GeoClue
    config_timezoneNote
}