FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

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

# Starship needs an active profile; allow commands and profile switchers to override this default.
# export AWS_PROFILE="${AWS_PROFILE:-tooling}"

# https://github.com/zsh-users/zsh-autosuggestions?tab=readme-ov-file#key-bindings
bindkey '^ ' autosuggest-accept
# Expands history expressions like !! or !$ when you press space
bindkey ' ' magic-space

# Custom Widgets
session-widget() { tmux-sessionizer }
zle -N session-widget
# bindkey "^[OP" session-widget # ^[OP == F1
bindkey "^f" session-widget

chooser-widget() { tmux-chooser }
zle -N chooser-widget
# bindkey "^[OQ" chooser-widget # ^[OQ == F2
bindkey "^b" chooser-widget

# PNPM
# after running: corepack enable
export COREPACK_ENABLE_STRICT=1
export PNPM_HOME="/Users/imiljan/.local/share/pnpm"
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

# pnpm
export PNPM_HOME="/Users/imiljan/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME/bin:"*) ;;
*) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# Bat
export BAT_THEME=tokyonight_night

# FZF
FZF_DEFAULT_OPTS="
  --height 90%
  --tmux 90%,80%
  --highlight-line
  --info=inline-right
  --ansi
  --layout=reverse
  --border
"

# https://github.com/folke/tokyonight.nvim/blob/main/extras/fzf/tokyonight_night.sh
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
  --color=bg+:#283457
  --color=bg:#16161e
  --color=border:#27a1b9
  --color=fg:#c0caf5
  --color=gutter:#16161e
  --color=header:#ff9e64
  --color=hl+:#2ac3de
  --color=hl:#2ac3de
  --color=info:#545c7e
  --color=marker:#ff007c
  --color=pointer:#ff007c
  --color=prompt:#2ac3de
  --color=query:#c0caf5:regular
  --color=scrollbar:#27a1b9
  --color=separator:#ff9e64
  --color=spinner:#ff007c
"

# https://github.com/junegunn/fzf?tab=readme-ov-file#key-bindings-for-command-line
PERVIEW_BIND="--bind 'ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up'"
# PERVIEW_BIND="--bind 'ctrl-y:preview-up,ctrl-e:preview-down,ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up'"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS

# CTRL-T For Files and Directories
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}' $PERVIEW_BIND"

# --bind 'ctrl-y:execute-silent(pbcopy <<< {})+abort'
# CTRL-R For History
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard; CTRL-/ for preview'
  $PERVIEW_BIND"

# ALT-C for Directories
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200' $PERVIEW_BIND"

# https://github.com/junegunn/fzf?tab=readme-ov-file#settings
export FZF_COMPLETION_OPTS='--border --info=inline'

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

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

# Add user site-packages directory to PATH
PYTHON_BIN_PATH="$(python3 -m site --user-base)/bin"
PATH="$PATH:$PYTHON_BIN_PATH"

#  PyEnv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Pipenv completion
eval "$(_PIPENV_COMPLETE=zsh_source pipenv)"

# Ruby
# eval "$(rbenv init - zsh)"
# export PATH="$HOME/.rbenv/bin:$PATH"

# Ngrok
# if command -v ngrok &>/dev/null; then
#   eval "$(ngrok completion)"
# fi

# snowflake
export SNOWFLAKE_USER="miljan.ignjatovic@perk.com"
export SNOWFLAKE_ACCOUNT="bg29839.eu-west-1"

# opencode
export PATH=/Users/imiljan/.opencode/bin:$PATH
if command -v opencode >/dev/null 2>&1; then
  source <(opencode --completions zsh)
fi

#1Password
# eval "$(op completion zsh)"
# compdef _op op
# source /Users/imiljan/.config/op/plugins.sh

export HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS=1

# vim: ft=sh
