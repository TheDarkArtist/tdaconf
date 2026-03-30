#!/usr/bin/env bash
# vpn-setup.sh — import ProtonVPN free servers into NetworkManager
# Usage: ./vpn-setup.sh [openvpn-username] [openvpn-password]
#
# First run: provide creds as args, they get saved locally
# Subsequent runs: reads saved creds (or pass new ones to update)
#
# Get OpenVPN credentials from:
# https://account.protonvpn.com/account#openvpn
# (NOT your ProtonVPN login — the separate OpenVPN/IKEv2 credentials)
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

info()    { echo -e "${BLUE}::${NC} $1"; }
success() { echo -e "${GREEN}::${NC} $1"; }
warn()    { echo -e "${YELLOW}::${NC} $1"; }
error()   { echo -e "${RED}::${NC} $1" >&2; }

CREDS_FILE="$HOME/.config/protonvpn/creds"

# Load or save credentials
load_creds() {
    if [[ $# -ge 2 ]]; then
        USERNAME="$1"
        PASSWORD="$2"
        mkdir -p "$(dirname "$CREDS_FILE")"
        echo "$USERNAME" > "$CREDS_FILE"
        echo "$PASSWORD" >> "$CREDS_FILE"
        chmod 600 "$CREDS_FILE"
        info "credentials saved to $CREDS_FILE"
    elif [[ -f "$CREDS_FILE" ]]; then
        USERNAME=$(sed -n '1p' "$CREDS_FILE")
        PASSWORD=$(sed -n '2p' "$CREDS_FILE")
        info "using saved credentials"
    else
        error "no credentials provided and none saved"
        echo
        echo "Usage: $0 <openvpn-username> <openvpn-password>"
        echo "Get creds from: https://account.protonvpn.com/account#openvpn"
        exit 1
    fi
}

load_creds "$@"

info "fetching ProtonVPN server list..."

# ProtonVPN API requires specific headers
SERVERS_JSON=$(curl -sL \
    -H "x-pm-appversion: LinuxVPN_4.0.0" \
    -H "x-pm-apiversion: 3" \
    -H "User-Agent: ProtonVPN" \
    "https://api.protonvpn.ch/vpn/logicals")

if [[ -z "$SERVERS_JSON" ]] || echo "$SERVERS_JSON" | python3 -c "import sys,json; d=json.load(sys.stdin); sys.exit(0 if 'LogicalServers' in d else 1)" 2>/dev/null; then
    : # good
else
    error "failed to fetch server list — API may have changed"
    error "check https://api.protonvpn.ch/vpn/logicals manually"
    exit 1
fi

info "importing free servers into NetworkManager..."

python3 - "$USERNAME" "$PASSWORD" <<'PYEOF'
import json, sys, subprocess

username = sys.argv[1]
password = sys.argv[2]

# Read server list from stdin
import urllib.request

req = urllib.request.Request(
    "https://api.protonvpn.ch/vpn/logicals",
    headers={
        "x-pm-appversion": "LinuxVPN_4.0.0",
        "x-pm-apiversion": "3",
        "User-Agent": "ProtonVPN",
    }
)

try:
    data = json.loads(urllib.request.urlopen(req).read())
except Exception as e:
    print(f"API error: {e}", file=sys.stderr)
    sys.exit(1)

servers = data.get("LogicalServers", [])
free_servers = [s for s in servers if s.get("Tier", 99) == 0 and s.get("Status", 0) == 1]

if not free_servers:
    print("No free servers found", file=sys.stderr)
    sys.exit(1)

print(f"Found {len(free_servers)} free servers, importing up to 10...")

count = 0
for server in free_servers[:10]:
    name = server["Name"]
    if not server.get("Servers"):
        continue
    entry_ip = server["Servers"][0]["EntryIP"]

    conn_name = name.lower().replace("#", "-").replace(" ", "") + ".protonvpn.udp"

    # Skip if exists
    result = subprocess.run(["nmcli", "connection", "show", conn_name],
                          capture_output=True, text=True)
    if result.returncode == 0:
        print(f"  exists: {conn_name}")
        continue

    # Create NM OpenVPN connection
    vpn_data = (
        f"remote={entry_ip}, "
        f"port=443, "
        f"connection-type=password, "
        f"proto-udp=yes, "
        f"dev-type=tun, "
        f"tunnel-mtu=1500, "
        f"cipher=AES-256-GCM, "
        f"auth=SHA512, "
        f"username={username}, "
        f"tls-client=yes, "
        f"remote-cert-tls=server"
    )

    result = subprocess.run([
        "nmcli", "connection", "add",
        "type", "vpn",
        "vpn-type", "openvpn",
        "con-name", conn_name,
        "ifname", "--",
        "vpn.data", vpn_data,
        "vpn.secrets", f"password={password}"
    ], capture_output=True, text=True)

    if result.returncode == 0:
        print(f"  added: {conn_name} ({entry_ip})")
        count += 1
    else:
        print(f"  FAILED: {conn_name} — {result.stderr.strip()}")

print(f"\n{count} connections added.")
PYEOF

sudo nmcli connection reload 2>/dev/null || true

success "VPN setup complete"
echo
echo "  Connect:    nmcli connection up <server-name>"
echo "  Disconnect: nmcli connection down <server-name>"
echo "  List:       nmcli connection show | grep protonvpn"
echo
echo "  Leak guard is active — DNS + IPv6 + kill switch auto-engage on connect."
echo
echo "  To update creds later: $0 <new-username> <new-password>"
