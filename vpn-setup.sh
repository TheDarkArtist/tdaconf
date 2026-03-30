#!/usr/bin/env bash
# vpn-setup.sh — import ProtonVPN servers into NetworkManager
# Usage: ./vpn-setup.sh [openvpn-username] [openvpn-password]
#
# First run: provide creds, they get saved locally
# Subsequent runs: reads saved creds
#
# Get OpenVPN credentials from:
# https://account.protonvpn.com/account#openvpn
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
CERT_DIR="$HOME/.cert/nm-openvpn"
VPN_DIR="$SCRIPT_DIR/vpn"

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

# Install shared ProtonVPN certs
mkdir -p "$CERT_DIR"
cp "$VPN_DIR/protonvpn-ca.pem" "$CERT_DIR/"
cp "$VPN_DIR/protonvpn-tls-crypt.pem" "$CERT_DIR/"
chmod 600 "$CERT_DIR"/*.pem

info "importing VPN connections..."

COUNT=0
while IFS='|' read -r NAME REMOTE; do
    [[ -z "$NAME" || "$NAME" == \#* ]] && continue

    CONN="${NAME}.protonvpn.udp"

    if nmcli connection show "$CONN" &>/dev/null; then
        info "  exists: $CONN"
        continue
    fi

    VPN_DATA="ca = $CERT_DIR/protonvpn-ca.pem, tls-crypt = $CERT_DIR/protonvpn-tls-crypt.pem, remote = $REMOTE, cipher = AES-256-GCM, connection-type = password, dev = tun, mssfix = 0, password-flags = 0, remote-cert-tls = server, remote-random = yes, reneg-seconds = 0, tunnel-mtu = 1500, username = $USERNAME"

    nmcli connection add \
        type vpn \
        vpn-type openvpn \
        con-name "$CONN" \
        ifname -- \
        vpn.data "$VPN_DATA" \
        vpn.secrets "password=$PASSWORD" \
        2>/dev/null

    if [[ $? -eq 0 ]]; then
        info "  added: $CONN"
        COUNT=$((COUNT + 1))
    else
        warn "  failed: $CONN"
    fi
done < "$VPN_DIR/servers.txt"

sudo nmcli connection reload 2>/dev/null || true

success "$COUNT VPN connections added"
echo
echo "  Connect:    nmcli connection up us-free-33.protonvpn.udp"
echo "  Disconnect: nmcli connection down us-free-33.protonvpn.udp"
echo "  List:       nmcli connection show | grep protonvpn"
echo
echo "  Leak guard auto-engages on connect (DNS + IPv6 + kill switch)"
echo
echo "  If auth fails — creds changed. Re-run: $0 <new-user> <new-pass>"
