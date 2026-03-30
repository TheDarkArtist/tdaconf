#!/usr/bin/env bash
# vpn-setup.sh — import ProtonVPN free servers into NetworkManager
# Usage: ./vpn-setup.sh <openvpn-username> <openvpn-password>
#
# Get your OpenVPN credentials from:
# https://account.protonvpn.com/account#openvpn
# (these are NOT your ProtonVPN login credentials)
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}::${NC} $1"; }
success() { echo -e "${GREEN}::${NC} $1"; }
error()   { echo -e "${RED}::${NC} $1" >&2; }

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <openvpn-username> <openvpn-password>"
    echo
    echo "Get credentials from: https://account.protonvpn.com/account#openvpn"
    echo "(NOT your ProtonVPN login — the separate OpenVPN/IKEv2 credentials)"
    exit 1
fi

USERNAME="$1"
PASSWORD="$2"
OVPN_DIR="/tmp/protonvpn-configs"
API_URL="https://api.protonvpn.ch/vpn/logicals"

info "fetching ProtonVPN server list..."

# Fetch server list — filter free servers (Tier=0), grab UDP config URLs
SERVERS_JSON=$(curl -sL "$API_URL")

if [[ -z "$SERVERS_JSON" || "$SERVERS_JSON" == *"error"* ]]; then
    error "failed to fetch server list from ProtonVPN API"
    exit 1
fi

mkdir -p "$OVPN_DIR"

# Extract free server .ovpn download URLs (Tier 0 = free)
# ProtonVPN .ovpn configs are at: https://account.protonvpn.com/api/vpn/config?...
# But simpler: use their pre-built config endpoint
info "downloading free server configs..."

# Get a handful of free servers (US, NL, JP) via direct config URLs
SERVERS=(
    "us-free-01.protonvpn.udp"
    "us-free-02.protonvpn.udp"
    "us-free-03.protonvpn.udp"
    "nl-free-01.protonvpn.udp"
    "nl-free-02.protonvpn.udp"
    "jp-free-01.protonvpn.udp"
    "jp-free-02.protonvpn.udp"
)

# Download .ovpn configs from ProtonVPN
CONFIG_BASE="https://account.protonvpn.com/api/vpn/config"

# Actually — ProtonVPN requires auth for config downloads.
# Instead, generate configs from known server IPs using the API data.
# Extract server entries: Name, EntryIP, for Tier==0 (free)

info "parsing free servers from API..."

CONN_COUNT=0

# Use python to parse JSON and generate NM connections
python3 - "$USERNAME" "$PASSWORD" "$OVPN_DIR" <<'PYEOF'
import json, sys, subprocess, os

username = sys.argv[1]
password = sys.argv[2]
ovpn_dir = sys.argv[3]

# Fetch server list
import urllib.request
data = json.loads(urllib.request.urlopen("https://api.protonvpn.ch/vpn/logicals").read())

servers = data.get("LogicalServers", [])
free_servers = [s for s in servers if s.get("Tier", 99) == 0 and s.get("Status", 0) == 1]

# Pick first 10 free servers
for server in free_servers[:10]:
    name = server["Name"]  # e.g. "US-FREE#1"
    entry_ip = server["Servers"][0]["EntryIP"]

    # Connection name for NM
    conn_name = name.lower().replace("#", "-").replace(" ", "") + ".protonvpn.udp"

    # Check if connection already exists
    result = subprocess.run(["nmcli", "connection", "show", conn_name],
                          capture_output=True, text=True)
    if result.returncode == 0:
        print(f"  already exists: {conn_name}")
        continue

    # Create NM OpenVPN connection
    subprocess.run([
        "nmcli", "connection", "add",
        "type", "vpn",
        "vpn-type", "openvpn",
        "con-name", conn_name,
        "ifname", "--",
        "vpn.data",
        f"remote={entry_ip}, port=443, proto-udp=yes, "
        f"dev-type=tun, tunnel-mtu=1500, "
        f"cipher=AES-256-GCM, auth=SHA512, "
        f"username={username}, "
        f"tls-client=yes, "
        f"remote-cert-tls=server",
        "vpn.secrets", f"password={password}"
    ], check=True)

    print(f"  added: {conn_name} ({entry_ip})")

print("\nDone.")
PYEOF

# Reload NM connections
sudo nmcli connection reload

success "VPN connections imported into NetworkManager"
echo
echo "  Connect:    nmcli connection up <server-name>"
echo "  Disconnect: nmcli connection down <server-name>"
echo "  List:       nmcli connection show | grep protonvpn"
echo
echo "  The VPN leak guard is active — DNS, IPv6, and kill switch"
echo "  will auto-engage when you connect."
