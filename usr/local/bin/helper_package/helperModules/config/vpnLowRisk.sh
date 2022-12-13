#!/bin/bash

function vpnLowRisk ()
{
    # Keys
        echo -e "\nSet Wireguard Key Regen to 72 hours"
            mullvad tunnel wireguard key rotation-interval set 72

        echo -e "\nRegen Wireguard Key"
            mullvad tunnel wireguard key regenerate

    # Location
        echo -e "\nSet US Relay"
            mullvad relay set location us
    
    # VPN Settings
        echo -e "\nAllow local LAN Devices"
            mullvad lan set allow
    
        echo -e "\nSet DNS to Block: Ads, Maleware, Tracking, Gambling, Adult"
            mullvad dns set default --block-ads --block-malware --block-trackers --block-gambling --block-adult-content

        echo -e "\nSet Protocol to Wireguard"
            mullvad relay set tunnel-protocol wireguard
       
    # Wireguard Settings
        echo -e "\nSet Port"
            mullvad relay set tunnel wireguard --port 51820

        echo -e "\nObfuscation Auto"
            mullvad obfuscation set mode auto

        echo -e "\nDisable Quantum Resistance"
            mullvad tunnel wireguard quantum-resistant-tunnel set off

        echo -e "\nDisable MultiHop"
            mullvad relay set tunnel wireguard --entry-location none

    # Connect
        echo -e "\nEnable Auto Connect"
            mullvad auto-connect set on

        echo -e "\nConnecting to Mullvad"
            mullvad connect
}