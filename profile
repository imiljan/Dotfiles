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

# Alias
alias dps="docker ps"
alias dvols="docker volume ls"
alias dnets="docker network ls"
alias dimgs="docker image ls"

alias dc="docker-compose"
alias dcud="docker-compose up -d"
alias dcu="docker-compose up"
alias dcd="docker-compose down"
alias dclf="docker-compose logs -f"

alias rmnm="find . -name "node_modules" -type d -prune -exec rm -rf '{}' +"
alias wstorml='wstorm -e'
alias vim='nvim'
# alias cat="bat --paging=never"
alias cat="bat --style plain"

fcd() {
    local dir
    dir=$(find ${1:-.} -type d -not -path '*/\.*' 2> /dev/null | fzf +m) && cd "$dir"
}

# Homebrew
# export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"

# libpq is keg-only, which means it was not symlinked into /opt/homebrew,
# because conflicts with postgres formula.
# If you need to have libpq first in your PATH uncomment next line

# export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Docker format
export FORMAT="ID\t{{.ID}}\nNAME\t{{.Names}}\nIMAGE\t{{.Image}}\nPORTS\t{{.Ports}}\nCOMMAND\t{{.Command}}\nCREATED\t{{.CreatedAt}}\nSTATUS\t{{.Status}}\n"
export LANG=en_US.UTF-8

# GCloud - Add gcloud completion
# source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
# source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

# Java - JEnv (This is replaced by jenv zsh plugin)
# export PATH="$HOME/.jenv/bin:$PATH"
# eval "$(jenv init -)"
# export PATH="$HOME/.jenv/plugins:$PATH"
# To setup JAVA_HOME run 'jenv enable-plugin export'
# Check other plugins 'jenv plugins'

# Maven
export M2_HOME=/opt/homebrew/Cellar/maven/3.9.6/libexec
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
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PAYH"
eval "$(pyenv init -)"
