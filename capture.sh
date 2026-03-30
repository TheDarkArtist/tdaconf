#!/usr/bin/env bash
# tdaconf capture — snapshot configs into repo with identity stripped
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR"
HOME_DIR="$REPO_DIR/home"
CONFIG_FILE="$REPO_DIR/config.conf"
REAL_HOME="$HOME"
REAL_USER="$(whoami)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}::${NC} $1"; }
success() { echo -e "${GREEN}::${NC} $1"; }
warn()    { echo -e "${YELLOW}::${NC} $1"; }
error()   { echo -e "${RED}::${NC} $1" >&2; }

# Parse config.conf into sources and ignore patterns
parse_config() {
    local -n _sources=$1
    local -n _ignores=$2

    while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
        line="${line%%#*}"          # strip inline comments
        line="${line%"${line##*[![:space:]]}"}" # trim trailing whitespace

        if [[ "$line" == !* ]]; then
            _ignores+=("${line#!}")
        else
            _sources+=("$line")
        fi
    done < "$CONFIG_FILE"
}

# Build rsync exclude args from ignore patterns
build_excludes() {
    local -n _patterns=$1
    local -n _args=$2

    for pat in "${_patterns[@]}"; do
        _args+=(--exclude "$pat")
    done
}

# Sync one source to repo
sync_source() {
    local src="$REAL_HOME/$1"
    local dest="$HOME_DIR/$1"

    if [[ ! -e "$src" ]]; then
        warn "skipping (not found): $src"
        return 0
    fi

    # Create parent directory
    mkdir -p "$(dirname "$dest")"

    if [[ -d "$src" ]]; then
        # Ensure trailing slash for rsync directory behavior
        [[ "$src" != */ ]] && src="$src/"
        [[ "$dest" != */ ]] && dest="$dest/"
        mkdir -p "$dest"
        rsync -a --checksum --delete "${EXCLUDE_ARGS[@]}" "$src" "$dest"
    else
        rsync -a --checksum "${EXCLUDE_ARGS[@]}" "$src" "$dest"
    fi
}

# Sanitize all text files in home/
sanitize() {
    info "sanitizing identity..."

    # Find all text files in home/
    while IFS= read -r -d '' file; do
        # Skip binary files
        if file "$file" | grep -qv text; then
            continue
        fi

        local modified=false

        # 1. Replace /home/<user> with __HOME__
        if grep -q "$REAL_HOME" "$file" 2>/dev/null; then
            sed -i "s|$REAL_HOME|__HOME__|g" "$file"
            modified=true
        fi

        # 2. Remove lines with secrets/tokens
        if grep -qE '(export\s+\w*(TOKEN|SECRET|SESSION|KEY)\s*=|BW_SESSION=|FIGMA_ACCESS_TOKEN=)' "$file" 2>/dev/null; then
            sed -i -E '/export\s+\w*(TOKEN|SECRET|SESSION)\s*=/d' "$file"
            sed -i '/BW_SESSION=/d' "$file"
            sed -i '/FIGMA_ACCESS_TOKEN=/d' "$file"
            modified=true
        fi

        # 3. Remove personal aliases and exports
        if grep -qE "^alias (cdw|cdp|claude-mem)=" "$file" 2>/dev/null; then
            sed -i -E '/^alias (cdw|cdp|claude-mem)=/d' "$file"
            modified=true
        fi
        if grep -q '^export PRJ=' "$file" 2>/dev/null; then
            sed -i '/^export PRJ=/d' "$file"
            modified=true
        fi

        # 4. Guard unguarded source lines for optional tools
        if grep -q '^source ".*\.openclaw' "$file" 2>/dev/null; then
            sed -i 's|^source "\(.*\.openclaw[^"]*\)"|[[ -f "\1" ]] \&\& source "\1"|' "$file"
            modified=true
        fi

        $modified && info "  sanitized: ${file#$REPO_DIR/}"
    done < <(find "$HOME_DIR" -type f -print0)

    # 5. Strip .gitconfig [user] block
    local gitconfig="$HOME_DIR/.gitconfig"
    if [[ -f "$gitconfig" ]]; then
        # Remove [user] section (from [user] to next section or EOF)
        sed -i '/^\[user\]/,/^\[/{/^\[user\]/d;/^\[/!d}' "$gitconfig"
        info "  stripped [user] from .gitconfig"
    fi
}

# Verify no identity leaked
verify() {
    info "verifying no identity leaks..."
    local leaked=false

    # Check for home path
    if grep -r "$REAL_HOME" "$HOME_DIR" --include='*' -l 2>/dev/null | head -5 | grep -q .; then
        error "LEAK: $REAL_HOME found in:"
        grep -r "$REAL_HOME" "$HOME_DIR" -l 2>/dev/null | head -10
        leaked=true
    fi

    # Check for email
    if grep -ri "sparrow\.kushagra\|kushagra\.sharma" "$HOME_DIR" -l 2>/dev/null | head -5 | grep -q .; then
        error "LEAK: personal email/name found in:"
        grep -ri "sparrow\.kushagra\|kushagra\.sharma" "$HOME_DIR" -l 2>/dev/null | head -10
        leaked=true
    fi

    # Check for tokens
    if grep -rE '(BW_SESSION|FIGMA_ACCESS_TOKEN|figd_)' "$HOME_DIR" -l 2>/dev/null | head -5 | grep -q .; then
        error "LEAK: tokens found in:"
        grep -rE '(BW_SESSION|FIGMA_ACCESS_TOKEN|figd_)' "$HOME_DIR" -l 2>/dev/null | head -10
        leaked=true
    fi

    if $leaked; then
        error "identity leaks detected — aborting commit"
        return 1
    fi

    success "clean — no identity found"
}

# Git commit and push
commit_and_push() {
    cd "$REPO_DIR"

    if git diff --quiet && git diff --cached --quiet && [[ -z "$(git ls-files --others --exclude-standard)" ]]; then
        success "no changes to commit"
        return 0
    fi

    git add -A
    git commit -m "config snapshot: $(date +'%Y-%m-%d %H:%M')"

    if git remote get-url origin &>/dev/null; then
        local branch
        branch="$(git symbolic-ref --short HEAD 2>/dev/null || echo main)"
        info "pushing to origin/$branch..."
        git push origin "$branch"
        success "pushed"
    else
        warn "no remote configured — skipping push"
    fi
}

# Main
main() {
    [[ ! -f "$CONFIG_FILE" ]] && { error "config.conf not found at $CONFIG_FILE"; exit 1; }

    local sources=()
    local ignores=()
    parse_config sources ignores

    EXCLUDE_ARGS=()
    build_excludes ignores EXCLUDE_ARGS

    info "capturing ${#sources[@]} sources..."

    local failed=0
    for src in "${sources[@]}"; do
        if sync_source "$src"; then
            info "  synced: $src"
        else
            failed=$((failed + 1))
        fi
    done

    [[ $failed -gt 0 ]] && warn "$failed source(s) failed to sync"

    sanitize
    verify || exit 1
    commit_and_push

    success "capture complete"
}

main "$@"
