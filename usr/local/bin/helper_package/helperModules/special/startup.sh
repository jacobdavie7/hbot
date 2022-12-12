#!/bin/bash

function startup
{
    firewallHome
    vpnLowRisk
    monitors
    xfceFix
    drawing
    
    sleep 2 # time for vpn to connect
        updater        
}