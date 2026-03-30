# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# if command -v tmux >/dev/null 2>&1; then
#   [ -z "$TMUX" ] && [ -z "$NO_TMUX" ] && exec tmux
# fi

# Load colours and then set fallback prompt
# Prompt preview:
# [user@hostname]-[~]
# >>>
autoload -U colors && colors
PS1="%{$fg[blue]%}%B[%b%{$fg[cyan]%}%n%{$fg[grey]%}%B@%b%{$fg[cyan]%}%m%{$fg[blue]%}%B]-%b%{$fg[blue]%}%B[%b%{$fg[white]%}%~%{$fg[blue]%}%B]%b
%{$fg[cyan]%}%B>>>%b%{$reset_color%} "

# ZSH history file
HISTSIZE=100
SAVEHIST=1000
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
export PATH="$HOME/Development/flutter/bin:/usr/lib/ccache/bin/:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/opt/bin:/usr/bin/core_perl:/usr/games/bin:$HOME/.cargo/bin/:$HOME/Development/go/bin/:$HOME/.config/composer/vendor/bin/:$HOME/.local/share/bin:$HOME/.local/bin:$PATH"

if [ -f ~/.zsh_aliases ]; then
  source ~/.zsh_aliases
fi

if [ -f ~/.zsh_aliases ]; then
  source ~/.zsh_functions
fi

source /usr/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# bun completions
[ -s "__HOME__/.bun/_bun" ] && source "__HOME__/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PRJ="__HOME__/Workspace/Projects/tdaweb/."

export TERMINAL=alacritty
export ANDROID_HOME="$HOME/Development/Android/Sdk"
# export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"
export GOPATH=$HOME/Development/go
export PATH="__HOME__/.bun/bin:$PATH"
export CAPACITOR_ANDROID_STUDIO_PATH="/sbin/android-studio"
export CHROME_EXECUTABLE='/sbin/chromium'

# pnpm
export PNPM_HOME="__HOME__/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# source __HOME__/.config/broot/launcher/bash/br


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# opencode
export PATH=__HOME__/.opencode/bin:$PATH

# OpenClaw Completion
source "__HOME__/.openclaw/completions/openclaw.zsh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '__HOME__/Development/google-cloud-sdk/path.zsh.inc' ]; then . '__HOME__/Development/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '__HOME__/Development/google-cloud-sdk/completion.zsh.inc' ]; then . '__HOME__/Development/google-cloud-sdk/completion.zsh.inc'; fi

