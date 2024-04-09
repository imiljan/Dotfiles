export XDG_CONFIG_HOME=$HOME/.config

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# place this after nvm initialization!
autoload -U add-zsh-hook
autoload -U compinit
compinit -i

load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc


# ----- Bat (better cat) -----
# Setup 
# mkdir -p "$(bat --config-dir)/themes"
# cd $(bat --config-dir)/themes
# curl -O https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme
# bat cache --build
export BAT_THEME=tokyonight_night

# FZF
eval "$(fzf --zsh)"

# TokioNight Night for fzf
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
--color=fg:#c0caf5,bg:#1a1b26,hl:#ff9e64 \
--color=fg+:#c0caf5,bg+:#292e42,hl+:#ff9e64 \
--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff \
--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"

# -- Use fd instead of fzf --
# CTRL-T For Files and Directories
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ALT-C for Directories
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"

# FROM https://github.com/junegunn/fzf?tab=readme-ov-file#settings
export FZF_COMPLETION_TRIGGER='~~'

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# https://github.com/junegunn/fzf?tab=readme-ov-file#key-bindings-for-command-line
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"                           "$@" ;;
    ssh)          fzf --preview 'dig {}'                                     "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}
# END FZF

fcd() {
    local dir
    dir=$(find ${1:-.} -maxdepth 2 -type d -not -path '*/\.*' 2> /dev/null | fzf +m) && cd "$dir"
}

ccd() {
  local dir
  dir=$(find ~/Code ~/Code/expense-robot ~/ -mindepth 1 -maxdepth 1 -type d | fzf) && cd "$dir"
}

# OpenSSL
# export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"

# libpq
# export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# GIT GPG signing
export GPG_TTY=$(tty)

# Docker format
export FORMAT="ID\t{{.ID}}\nNAME\t{{.Names}}\nIMAGE\t{{.Image}}\nPORTS\t{{.Ports}}\nCOMMAND\t{{.Command}}\nCREATED\t{{.CreatedAt}}\nSTATUS\t{{.Status}}\n"

# GCloud - Add gcloud completion
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

# This is replaced by jenv zsh plugin
# Java - JEnv
# export PATH="$HOME/.jenv/bin:$PATH"
# eval "$(jenv init -)"
# export PATH="$HOME/.jenv/plugins:$PATH"

# Maven
export M2_HOME=/opt/homebrew/Cellar/maven/3.9.3/libexec
export M2=$M2_HOME/bin
export PATH=$PATH:$M2_HOME/bin

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Android studio
export CAPACITOR_ANDROID_STUDIO_PATH=~/Applications/Android\ Studio.app

# Python
# PYTHON_BIN_PATH="$(python3 -m site --user-base)/bin"
# PATH="$PATH:$PYTHON_BIN_PATH"

# Python - PyEnv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Ngrok
if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

# TMUX-SESSIONIZER
# bindkey -s ^f "tmux-sessionizer\n"
# bindkey -s F1 "tmux-sessionizer\n"

goWork() {
    cp ~/.npm_work_rc ~/.npmrc
    cp ~/.ssh_config_work ~/.ssh/config
}

goPersonal() {
    cp ~/.npm_personal_rc ~/.npmrc
    cp ~/.ssh_config_personal ~/.ssh/config
}
