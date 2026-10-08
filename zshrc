# OPENSPEC:START
# OpenSpec shell completions configuration
fpath=("/Users/imiljan/.oh-my-zsh/custom/completions" $fpath)
autoload -Uz compinit
compinit
# OPENSPEC:END

# https://github.com/ohmyzsh/ohmyzsh/wiki/Settings#main-settings
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

plugins=(
  git
  # docker
  # jira
  vi-mode

  zsh-autosuggestions
  zsh-syntax-highlighting
)

# https://github.com/ohmyzsh/ohmyzsh/wiki/Settings#completion-settings

# https://github.com/ohmyzsh/ohmyzsh/wiki/Settings#library-settings
DISABLE_UNTRACKED_FILES_DIRTY=true
HIST_STAMPS="yyyy-mm-dd"

source $ZSH/oh-my-zsh.sh
source $HOME/.profile
source $HOME/.alias
source $HOME/Dotfiles/secrets

source <(fzf --zsh)
eval "$(starship init zsh)"

# PIP_INDEX_URL and UV_DEFAULT_INDEX
eval $(tk shell-setup)
