#!/bin/bash

function config_vpn_mobile ()
{
    # Deploy Home Firewall Ruleset
        echo -e "\nCall the Home Limited Firewall Ruleset"
            firewall_home_limited_vpn

    # Keys
        echo -e "\nSet Wireguard Key Regen to 72 hours"
            mullvad tunnel set wireguard --rotation-interval 72

    # Location
        echo -e "\nSet US Relay"
            mullvad relay set location us
    
    # VPN Settings
        echo -e "\nBlock local LAN Devices"
            mullvad lan set block
    
        echo -e "\nSet DNS to Block: Ads, Maleware, Tracking, Gambling, Adult"
            mullvad dns set default --block-ads --block-malware --block-trackers --block-gambling --block-adult-content

        echo -e "\nSet Protocol to Wireguard"
            mullvad relay set tunnel-protocol wireguard
       
    # Wireguard Settings
        echo -e "\nSet Port to 51820"
            mullvad relay set tunnel wireguard --port 51820

        echo -e "\nObfuscation Auto"
            mullvad obfuscation set mode auto

        echo -e "\nEnable Quantum Resistance"
            mullvad tunnel set wireguard --quantum-resistant on

        echo -e "\nDisable MultiHop"
            mullvad relay set location none

    # Connect
        echo -e "\nEnable Auto Connect"
            mullvad auto-connect set on

        echo -e "\nConnecting to Mullvad"
            mullvad connect
}