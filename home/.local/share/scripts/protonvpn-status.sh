#!/usr/bin/env bash
# ProtonVPN status for polybar
# Dynamically detects any active ProtonVPN connection

active=$(nmcli -t -f NAME,TYPE connection show --active 2>/dev/null | grep ":vpn" | grep -i protonvpn | cut -d: -f1)

if [[ -n "$active" ]]; then
    # Extract short server name: "us-free-33.protonvpn.udp" → "US-33"
    short=$(echo "$active" | sed 's/\.protonvpn.*//; s/-free//' | tr '[:lower:]' '[:upper:]')
    echo "󰌗 $short"
else
    echo "󰌗 OFF"
fi
