# OPENSPEC:START
# OpenSpec shell completions configuration
fpath=("$HOME/.oh-my-zsh/custom/completions" $fpath)
# compinit is run once by oh-my-zsh below; running it here too doubled the work.
# OPENSPEC:END

# Homebrew completions must be on fpath before oh-my-zsh runs compinit.
# HOMEBREW_PREFIX comes from `brew shellenv` in ~/.zprofile.
fpath=("${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions" $fpath)

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

_cached_source starship-init starship starship init zsh

# PIP_INDEX_URL and UV_DEFAULT_INDEX
eval $(tk shell-setup)

export PYTHONDONTWRITEBYTECODE=1
