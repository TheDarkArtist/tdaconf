#!/usr/bin/env bash
# tdaconf deploy — bootstrap a fresh Arch Linux install
# Usage: git clone <repo> /tmp/tdaconf && /tmp/tdaconf/deploy.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$SCRIPT_DIR/home"
PKG_FILE="$SCRIPT_DIR/packages.txt"

# Detect actual user home even when run with sudo
if [[ -n "${SUDO_USER:-}" ]]; then
    REAL_USER="$SUDO_USER"
    REAL_HOME="$(getent passwd "$SUDO_USER" | cut -d: -f6)"
else
    REAL_USER="$(whoami)"
    REAL_HOME="$HOME"
fi
TARGET_HOME="${TARGET_HOME:-$REAL_HOME}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}::${NC} $1"; }
success() { echo -e "${GREEN}::${NC} $1"; }
warn()    { echo -e "${YELLOW}::${NC} $1"; }
error()   { echo -e "${RED}::${NC} $1" >&2; }
header()  { echo -e "\n${BOLD}${BLUE}==> $1${NC}"; }

# Check we're on Arch
check_arch() {
    if [[ ! -f /etc/arch-release ]]; then
        error "this script is for Arch Linux only"
        exit 1
    fi
}

# Check sudo access
check_sudo() {
    if [[ $EUID -eq 0 ]]; then
        if [[ -n "${SUDO_USER:-}" ]]; then
            info "running via sudo — deploying configs to $TARGET_HOME (user: $REAL_USER)"
        else
            warn "running as root directly — configs will deploy to $TARGET_HOME"
        fi
        SUDO=""
    else
        if ! sudo -v 2>/dev/null; then
            error "need sudo access to install packages"
            exit 1
        fi
        SUDO="sudo"
    fi
}

# Install yay (AUR helper)
install_yay() {
    header "Installing yay"

    if command -v yay &>/dev/null; then
        info "yay already installed"
        return 0
    fi

    info "building yay from AUR..."
    local yay_dir="/tmp/yay-install"
    rm -rf "$yay_dir"

    # makepkg can't run as root — must run as the actual user
    if [[ $EUID -eq 0 ]]; then
        sudo -u "$REAL_USER" bash -c "
            git clone https://aur.archlinux.org/yay.git '$yay_dir' &&
            cd '$yay_dir' &&
            makepkg -si --noconfirm
        "
    else
        git clone https://aur.archlinux.org/yay.git "$yay_dir"
        cd "$yay_dir" && makepkg -si --noconfirm
        cd "$SCRIPT_DIR"
    fi

    rm -rf "$yay_dir"

    if command -v yay &>/dev/null; then
        success "yay installed"
    else
        warn "yay installation failed — AUR packages will be skipped"
    fi
}

# Install packages from packages.txt
install_packages() {
    header "Installing packages"

    [[ ! -f "$PKG_FILE" ]] && { error "packages.txt not found"; exit 1; }

    # Parse package list (skip comments and empty lines)
    local packages=()
    while IFS= read -r line; do
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
        packages+=("$line")
    done < "$PKG_FILE"

    info "installing ${#packages[@]} packages..."

    if command -v yay &>/dev/null; then
        # yay handles both official repos and AUR
        # Must run as normal user, not root
        if [[ $EUID -eq 0 ]]; then
            sudo -u "$REAL_USER" yay -S --needed --noconfirm --answerdiff None --answerclean None --removemake --ask 4 "${packages[@]}"
        else
            yay -S --needed --noconfirm --answerdiff None --answerclean None --removemake --ask 4 "${packages[@]}"
        fi
    else
        # Fallback to pacman (AUR packages will fail, that's fine)
        $SUDO pacman -S --needed --noconfirm "${packages[@]}" || {
            warn "some packages failed — AUR packages need yay"
        }
    fi

    success "packages installed"
}

# Install powerlevel10k
# Always git clone to /usr/share/powerlevel10k/ — the Arch pacman package
# installs to a different path that doesn't match .zshrc's source line
install_p10k() {
    header "Installing powerlevel10k"

    local p10k_dir="/usr/share/powerlevel10k"

    if [[ -d "$p10k_dir" ]]; then
        info "powerlevel10k already installed at $p10k_dir"
        return 0
    fi

    info "cloning powerlevel10k..."
    $SUDO git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"

    success "powerlevel10k installed"
}

# Deploy config files
deploy_configs() {
    header "Deploying configs"

    if [[ ! -d "$HOME_DIR" ]]; then
        error "home/ directory not found — run capture.sh first"
        exit 1
    fi

    # Backup existing configs
    local backup_dir="$TARGET_HOME/.tdaconf-backup-$(date +%Y%m%d-%H%M%S)"
    info "backing up existing configs to $backup_dir"
    mkdir -p "$backup_dir"

    # Find what would be overwritten and back it up
    while IFS= read -r -d '' file; do
        local rel="${file#$HOME_DIR/}"
        local target="$TARGET_HOME/$rel"
        if [[ -e "$target" ]]; then
            local backup_path="$backup_dir/$rel"
            mkdir -p "$(dirname "$backup_path")"
            cp -a "$target" "$backup_path"
        fi
    done < <(find "$HOME_DIR" -type f -print0)

    # Check if backup is empty (nothing to back up)
    if [[ -z "$(ls -A "$backup_dir" 2>/dev/null)" ]]; then
        rmdir "$backup_dir" 2>/dev/null || true
        info "no existing configs to back up"
    else
        success "backup saved to $backup_dir"
    fi

    # Deploy with rsync
    rsync -a --checksum "$HOME_DIR/" "$TARGET_HOME/"

    # Fix ownership if run via sudo (rsync as root makes files root-owned)
    if [[ -n "${SUDO_USER:-}" ]]; then
        chown -R "$REAL_USER:$REAL_USER" "$TARGET_HOME/.config" "$TARGET_HOME/.local" \
            "$TARGET_HOME/.zshrc" "$TARGET_HOME/.zsh_aliases" "$TARGET_HOME/.zsh_functions" \
            "$TARGET_HOME/.profile" "$TARGET_HOME/.xprofile" "$TARGET_HOME/.xinitrc" \
            "$TARGET_HOME/.tmux.conf" "$TARGET_HOME/.p10k.zsh" "$TARGET_HOME/.gitconfig" 2>/dev/null || true
        info "fixed file ownership for $REAL_USER"
    fi

    success "configs deployed to $TARGET_HOME"
}

# Expand __HOME__ placeholder in all deployed files
expand_placeholders() {
    header "Expanding placeholders"

    local count=0
    while IFS= read -r -d '' file; do
        # Skip binary files
        if file "$file" | grep -qv text; then
            continue
        fi

        if grep -q '__HOME__' "$file" 2>/dev/null; then
            sed -i "s|__HOME__|$TARGET_HOME|g" "$file"
            count=$((count + 1))
        fi
    done < <(find "$TARGET_HOME/.config" "$TARGET_HOME/.local" \
        "$TARGET_HOME/.zshrc" "$TARGET_HOME/.zsh_aliases" \
        "$TARGET_HOME/.zsh_functions" "$TARGET_HOME/.profile" \
        "$TARGET_HOME/.xprofile" "$TARGET_HOME/.xinitrc" \
        "$TARGET_HOME/.tmux.conf" "$TARGET_HOME/.p10k.zsh" \
        "$TARGET_HOME/.gitconfig" \
        -type f -print0 2>/dev/null)

    info "expanded placeholders in $count files"
}

# Set zsh as default shell
set_default_shell() {
    header "Setting default shell"

    local zsh_path
    zsh_path="$(which zsh 2>/dev/null || echo /usr/bin/zsh)"

    if [[ "$(getent passwd "$REAL_USER" | cut -d: -f7)" == "$zsh_path" ]]; then
        info "zsh is already the default shell for $REAL_USER"
        return 0
    fi

    chsh -s "$zsh_path" "$REAL_USER"
    success "default shell set to zsh for $REAL_USER"
}

# Make scripts executable
fix_permissions() {
    header "Fixing permissions"

    local script_dirs=(
        "$TARGET_HOME/.local/share/scripts"
        "$TARGET_HOME/.local/share/bin"
        "$TARGET_HOME/bin"
    )

    for dir in "${script_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            chmod +x "$dir"/* 2>/dev/null || true
            info "made scripts executable in $dir"
        fi
    done
}

# Enable essential services
enable_services() {
    header "Enabling services"

    # System services
    $SUDO systemctl enable --now NetworkManager 2>/dev/null || true
    info "NetworkManager enabled"

    # Pipewire user services (need user lingering for --user without active session)
    $SUDO loginctl enable-linger "$REAL_USER" 2>/dev/null || true
    sudo -u "$REAL_USER" systemctl --user enable pipewire pipewire-pulse wireplumber 2>/dev/null || true
    info "pipewire user services enabled"
}

# Print summary
print_summary() {
    echo
    echo -e "${BOLD}${GREEN}=== Deploy complete ===${NC}"
    echo
    echo "  What happened:"
    echo "    - Packages installed via pacman"
    echo "    - Configs deployed to $TARGET_HOME"
    echo "    - Powerlevel10k installed"
    echo "    - Zsh set as default shell"
    echo "    - Scripts made executable"
    echo
    echo "  What you need to do:"
    echo "    1. Log out and back in (or run: exec zsh)"
    echo "    2. Open nvim — lazy.nvim will auto-install plugins"
    echo "    3. Set your git identity: git config --global user.name/email"
    echo "    4. Generate SSH keys if needed: ssh-keygen -t ed25519"
    echo
    echo "  Your previous configs were backed up (if any existed)."
    echo
}

# Main
main() {
    echo -e "${BOLD}tdaconf deploy — Arch Linux bootstrapper${NC}"
    echo

    check_arch
    check_sudo
    install_yay
    install_packages
    install_p10k
    deploy_configs
    expand_placeholders
    set_default_shell
    fix_permissions
    enable_services
    print_summary
}

main "$@"
