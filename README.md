# tdaconf

System bootstrapper for Arch Linux. One command to deploy a full i3 rice on a fresh install.

## Usage

**On a new machine:**
```bash
sudo pacman -S git
git clone https://github.com/TheDarkArtist/tdaconf.git /tmp/tdaconf
sudo /tmp/tdaconf/deploy.sh
startx
```

**To update configs from source machine:**
```bash
./capture.sh
```

## What it deploys

- i3 + polybar + picom + rofi + alacritty + dunst
- Zsh + powerlevel10k + tmux
- Neovim with lazy.nvim + LSP + treesitter
- Polybar scripts, wallpapers, utility scripts
- NetworkManager, flameshot, ranger, thunar, firefox, chromium
