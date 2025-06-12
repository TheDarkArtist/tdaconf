# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load colours and then set fallback prompt
# Prompt preview:
# [user@hostname]-[~]
# >>>
autoload -U colors && colors
PS1="%{$fg[blue]%}%B[%b%{$fg[cyan]%}%n%{$fg[grey]%}%B@%b%{$fg[cyan]%}%m%{$fg[blue]%}%B]-%b%{$fg[blue]%}%B[%b%{$fg[white]%}%~%{$fg[blue]%}%B]%b
%{$fg[cyan]%}%B>>>%b%{$reset_color%} "

# ZSH history file
HISTSIZE=100
SAVEHIST=100
HISTFILE=~/.zsh_history

# Fancy auto-complete
autoload -Uz compinit
zstyle ':completion:*' menu select=0
zmodload zsh/complist
zstyle ':completion:*' format '>>> %d'
compinit
_comp_options+=(globdots) # hidden files are included


# precmd(){ pw-play ~/.local/share/sounds/beep.wav}

# Keybindings section
bindkey -e
bindkey '^[[7~' beginning-of-line                               # Home key
bindkey '^[[H' beginning-of-line                                # Home key
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line                # [Home] - Go to beginning of line
fi
bindkey '^[[8~' end-of-line                                     # End key
bindkey '^[[F' end-of-line                                     # End key
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line                       # [End] - Go to end of line
fi
bindkey '^[[2~' overwrite-mode                                  # Insert key
bindkey '^[[3~' delete-char                                     # Delete key
bindkey '^[[C'  forward-char                                    # Right key
bindkey '^[[D'  backward-char                                   # Left key
bindkey '^[[5~' history-beginning-search-backward               # Page up key
bindkey '^[[6~' history-beginning-search-forward                # Page down key

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word                                     #
bindkey '^[Od' backward-word                                    #
bindkey '^[[1;5D' backward-word                                 #
bindkey '^[[1;5C' forward-word                                  #
bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                                             # Shift+tab undo last action

export LD_PRELOAD=""
export EDITOR="nvim"
export PATH="$HOME/Development/flutter/bin:$HOME/bin:/usr/lib/ccache/bin/:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/opt/bin:/usr/bin/core_perl:/usr/games/bin:$HOME/.cargo/bin/:$HOME/Development/go/bin/:$HOME/.config/composer/vendor/bin/:$PATH"

if [ -f ~/.zsh_aliases ]; then
  source ~/.zsh_aliases
fi

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# bun completions
[ -s "/home/tda/.bun/_bun" ] && source "/home/tda/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PRJ="/home/tda/Workspace/Projects/tda-web/."

export TERMINAL=alacritty
export ANDROID_HOME="$HOME/Development/Android/Sdk"
export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"
export GOPATH=$HOME/Development/go
export PATH="/home/tda/.bun/bin:$PATH"
export CAPACITOR_ANDROID_STUDIO_PATH="/sbin/android-studio"

# pnpm
export PNPM_HOME="/home/tda/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
