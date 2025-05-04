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

# https://github.com/zsh-users/zsh-autosuggestions?tab=readme-ov-file#key-bindings
bindkey '^ ' autosuggest-accept

session-widget() { tmux-sessionizer }
zle -N session-widget
# bindkey "^[OP" session-widget # ^[OP == F1
bindkey "^f" session-widget

chooser-widget() { tmux-chooser }
zle -N chooser-widget
# bindkey "^[OQ" chooser-widget # ^[OQ == F2
bindkey "^b" chooser-widget

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

autoload -U add-zsh-hook

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
# --color=bg+:#283457
# --color=bg:#16161e
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
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
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

# Java - JEnv
eval "$(jenv init -)"
export PATH="$HOME/.jenv/bin:$PATH"
export PATH="$HOME/.jenv/plugins:$PATH"
export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"
alias jenv_set_java_home='export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"'

# Maven
export M2_HOME=/opt/homebrew/Cellar/maven/3.9.9/libexec
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
PYTHON_BIN_PATH="$(python3 -m site --user-base)/bin"
PATH="$PATH:$PYTHON_BIN_PATH"

#  PyEnv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Pipenv completion
eval "$(_PIPENV_COMPLETE=zsh_source pipenv)"

# Ruby
eval "$(rbenv init - zsh)"
export PATH="$HOME/.rbenv/bin:$PATH"

# Ngrok
# if command -v ngrok &>/dev/null; then
#   eval "$(ngrok completion)"
# fi


