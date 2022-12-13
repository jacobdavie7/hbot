#!/bin/bash

function startup
{
    firewallHome
    vpnLowRisk
    drawing
    monitors     
       
    sleep 2 # time for vpn to connect
        updater        
}