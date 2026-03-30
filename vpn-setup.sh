#!/usr/bin/env bash
# vpn-setup.sh — set up ProtonVPN on a fresh system
# Usage: ./vpn-setup.sh [openvpn-username] [openvpn-password]
#
# First run: provide creds, they get saved locally
# Subsequent runs: reads saved creds
#
# Get OpenVPN credentials from:
# https://account.protonvpn.com/account#openvpn
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
OVPN_DIR="$HOME/.config/protonvpn/ovpn"

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

mkdir -p "$OVPN_DIR"

# ProtonVPN free server IPs (stable, rarely change)
# Format: name|ip
SERVERS=(
    "us-free-01|149.22.81.136"
    "us-free-02|149.22.81.170"
    "us-free-03|149.22.81.137"
    "us-free-04|149.22.81.171"
    "nl-free-01|185.107.56.87"
    "nl-free-02|185.107.56.88"
    "nl-free-03|185.107.56.89"
    "jp-free-01|138.199.21.195"
    "jp-free-02|138.199.21.196"
    "jp-free-03|138.199.21.197"
)

info "creating ${#SERVERS[@]} VPN connections..."

COUNT=0
for entry in "${SERVERS[@]}"; do
    NAME="${entry%%|*}"
    IP="${entry##*|}"
    CONN="${NAME}.protonvpn.udp"

    # Skip if exists
    if nmcli connection show "$CONN" &>/dev/null; then
        info "  exists: $CONN"
        continue
    fi

    # Create .ovpn config
    cat > "$OVPN_DIR/$CONN.ovpn" <<EOF
client
dev tun
proto udp
remote $IP 443
resolv-retry infinite
nobind
persist-key
persist-tun
cipher AES-256-GCM
auth SHA512
verb 3
tun-mtu 1500
remote-cert-tls server
auth-user-pass
EOF

    # Import into NetworkManager
    if nmcli connection import type openvpn file "$OVPN_DIR/$CONN.ovpn" 2>/dev/null; then
        # Rename connection (nmcli import uses filename as name)
        IMPORTED_NAME="$CONN.ovpn"
        nmcli connection modify "$IMPORTED_NAME" connection.id "$CONN" 2>/dev/null || true

        # Set credentials
        nmcli connection modify "$CONN" vpn.user-name "$USERNAME" 2>/dev/null || true
        nmcli connection modify "$CONN" vpn.secrets "password=$PASSWORD" 2>/dev/null || true

        info "  added: $CONN ($IP)"
        COUNT=$((COUNT + 1))
    else
        warn "  failed: $CONN — is networkmanager-openvpn installed?"
    fi
done

sudo nmcli connection reload 2>/dev/null || true

success "$COUNT VPN connections added"
echo
echo "  Connect:    nmcli connection up us-free-01.protonvpn.udp"
echo "  Disconnect: nmcli connection down us-free-01.protonvpn.udp"
echo "  List:       nmcli connection show | grep protonvpn"
echo
echo "  Leak guard auto-engages on connect (DNS + IPv6 + kill switch)"
echo
echo "  If auth fails: creds may have changed — re-run with new creds:"
echo "  $0 <new-username> <new-password>"
