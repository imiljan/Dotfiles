# https://github.com/ohmyzsh/ohmyzsh/wiki/Settings#main-settings
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

plugins=(
  git
  docker
  jira
  vi-mode

  zsh-autosuggestions
  zsh-syntax-highlighting
)

# https://github.com/ohmyzsh/ohmyzsh/wiki/Settings#completion-settings
COMPLETION_WAITING_DOTS=true

# https://github.com/ohmyzsh/ohmyzsh/wiki/Settings#library-settings
ENABLE_CORRECTION=true
DISABLE_UNTRACKED_FILES_DIRTY=true
HIST_STAMPS="yyyy-mm-dd"

source $HOME/.profile
source $ZSH/oh-my-zsh.sh
source $HOME/.alias

source <(fzf --zsh)
eval "$(starship init zsh)"
