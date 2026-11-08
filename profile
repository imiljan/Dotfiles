# Homebrew completions are added to fpath in zshrc, before oh-my-zsh runs compinit.

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_HOME="$HOME/.local/share"

export EDITOR="nvim"

export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml
export EZA_CONFIG_DIR=$XDG_CONFIG_HOME/eza

# Cache the output of slow `eval "$(tool init)"` style commands.
# The cache is rebuilt when BINARY is newer than it. To force a rebuild: rm -rf ~/.cache/zsh
#   _cached_init NAME BINARY COMMAND...    write the cache if needed; its path is in $REPLY
#   _cached_source NAME BINARY COMMAND...  the same, then source it
# Some scripts (fzf's) break when sourced inside a function; for those use
#   _cached_init ... && source "$REPLY"
_cached_init() {
  local name=$1 bin=$2
  shift 2
  REPLY="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/$name.zsh"
  local bin_path=${commands[$bin]:A}
  [[ -n $bin_path ]] || return 1
  if [[ ! -s $REPLY || $bin_path -nt $REPLY ]]; then
    mkdir -p "${REPLY:h}"
    "$@" >|"$REPLY" 2>/dev/null || { rm -f "$REPLY"; return 1; }
  fi
}
_cached_source() {
  _cached_init "$@" && source "$REPLY"
}

# Starship needs an active profile; allow commands and profile switchers to override this default.
# export AWS_PROFILE="${AWS_PROFILE:-tooling}"

# https://github.com/zsh-users/zsh-autosuggestions?tab=readme-ov-file#key-bindings
bindkey '^ ' autosuggest-accept
# Expands history expressions like !! or !$ when you press space
bindkey ' ' magic-space

# Custom Widgets
# Inside Rex ($REX_SESSION is set) use Rex's sessions instead of starting tmux.
session-widget() {
  if [[ -n $REX_SESSION ]]; then
    rex-sessionizer
  else
    tmux-sessionizer
  fi
}
zle -N session-widget
# bindkey "^[OP" session-widget # ^[OP == F1
bindkey "^f" session-widget

chooser-widget() {
  if [[ -n $REX_SESSION ]]; then
    zle -M "In Rex, use cmd+k to switch sessions"
  else
    tmux-chooser
  fi
}
zle -N chooser-widget
# bindkey "^[OQ" chooser-widget # ^[OQ == F2
bindkey "^b" chooser-widget

# PNPM
# after running: corepack enable
export COREPACK_ENABLE_STRICT=1
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# NVM
export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Smart NVM loading hook
# Checks if an .nvmrc file exists in the current directory or parent directories
load-nvmrc() {
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    local node_version="$(nvm version)"

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

# Lazy load NVM
# This function replaces itself with the real nvm command upon first use,
# or if we enter a directory with .nvmrc
_load_nvm() {
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
}

# Define nvm command to lazy load
nvm() {
  unset -f nvm node npm npx yarn pnpm
  _load_nvm
  nvm "$@"
}

# Define other node commands to lazy load nvm first
for cmd in node npm npx yarn pnpm; do
  eval "${cmd}() { unset -f nvm node npm npx yarn pnpm; _load_nvm; ${cmd} \"\$@\"; }"
done

# Check for .nvmrc on directory change, but strictly ONLY if .nvmrc exists
# to avoid loading nvm unnecessarily
autoload -U add-zsh-hook
_check_nvmrc() {
  if [ -f ".nvmrc" ]; then
    if ! command -v nvm_find_nvmrc &> /dev/null; then
      unset -f nvm node npm npx yarn pnpm
      _load_nvm
    fi
    load-nvmrc
  fi
}
add-zsh-hook chpwd _check_nvmrc
# Run check on startup too
_check_nvmrc

# Bat
export BAT_THEME=tokyonight_night

# FZF: options, helpers and key bindings live in ~/Dotfiles/zsh/fzf.zsh
source "$HOME/Dotfiles/zsh/fzf.zsh"

# OpenSSL
# export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"

# libpq
# export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Postgresql@12
# export PATH="/opt/homebrew/opt/postgresql@12/bin:$PATH"

# GIT GPG signing
export GPG_TTY=$(tty)

# Docker format
export FORMAT="ID\t{{.ID}}\nNAME\t{{.Names}}\nIMAGE\t{{.Image}}\nPORTS\t{{.Ports}}\nCOMMAND\t{{.Command}}\nCREATED\t{{.CreatedAt}}\nSTATUS\t{{.Status}}\n"

# GCloud - Add gcloud completion
# source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
# source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

# Lazy load GCloud
gcloud() {
  if [ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]; then
    source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
    source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
    unset -f gcloud
    gcloud "$@"
  else
    echo "Google Cloud SDK not found"
  fi
}

# Java - JEnv
# eval "$(jenv init -)"
# export PATH="$HOME/.jenv/bin:$PATH"
# export PATH="$HOME/.jenv/plugins:$PATH"
# export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"

# Maven
# export M2_HOME=/opt/homebrew/Cellar/maven/3.9.9/libexec
# export M2=$M2_HOME/bin
# export PATH=$PATH:$M2_HOME/bin

# Android
# export ANDROID_HOME=$HOME/Library/Android/sdk
# export PATH=$PATH:$ANDROID_HOME/emulator
# export PATH=$PATH:$ANDROID_HOME/tools
# export PATH=$PATH:$ANDROID_HOME/tools/bin
# export PATH=$PATH:$ANDROID_HOME/platform-tools

# Android studio
# export CAPACITOR_ANDROID_STUDIO_PATH=~/Applications/Android\ Studio.app

# Python
# Foy Python artifactory - See secrets

# Add user site-packages bin directories to PATH.
# Was `python3 -m site --user-base` (a Python start on every shell). With pyenv's Python that
# is ~/.local (already on PATH); with Homebrew's it is ~/Library/Python/<version>.
for _d in "$HOME"/Library/Python/*/bin(N); do PATH="$PATH:$_d"; done
unset _d

#  PyEnv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
_cached_source pyenv-init pyenv pyenv init - zsh

# Pipenv completion
_cached_source pipenv-completion pipenv env _PIPENV_COMPLETE=zsh_source pipenv

# Ruby
# eval "$(rbenv init - zsh)"
# export PATH="$HOME/.rbenv/bin:$PATH"

# Ngrok
# if command -v ngrok &>/dev/null; then
#   eval "$(ngrok completion)"
# fi

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
_cached_source opencode-completion opencode opencode --completions zsh

#1Password
# eval "$(op completion zsh)"
# compdef _op op
# source /Users/imiljan/.config/op/plugins.sh

export HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS=1

# vim: ft=sh
