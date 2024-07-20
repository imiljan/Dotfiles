export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="cobalt2"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"
HIST_IGNORE_SPACE="true"

plugins=(
  git
  docker
  jira
  vi-mode

  zsh-autosuggestions
  zsh-syntax-highlighting
)

# https://github.com/zsh-users/zsh-autosuggestions?tab=readme-ov-file#key-bindings
bindkey '^ ' autosuggest-accept

source $HOME/.profile
source $ZSH/oh-my-zsh.sh
source $HOME/.alias

source <(fzf --zsh)

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

