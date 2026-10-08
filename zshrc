fpath=("$HOME/.oh-my-zsh/custom/completions" $fpath)
# compinit is run once by oh-my-zsh below; running it here too doubled the work.

# Homebrew completions must be on fpath before oh-my-zsh runs compinit.
# HOMEBREW_PREFIX comes from `brew shellenv`
eval "$(/opt/homebrew/bin/brew shellenv)"
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
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY HIST_IGNORE_DUPS

source $ZSH/oh-my-zsh.sh
source $HOME/.profile
source $HOME/.alias
source $HOME/Dotfiles/secrets

source <(fzf --zsh)
eval "$(starship init zsh)"

# PIP_INDEX_URL and UV_DEFAULT_INDEX
eval "$(tk shell-setup)"

# mise: node, python, java, pnpm (replaces nvm, pyenv, jenv). Keep last so its PATH wins.
eval "$(mise activate zsh)"

# PATH hygiene: keep first occurrence of each entry (-U ties path to PATH, so later edits dedupe too),
# then drop directories that don't exist (stale entries inherited from the launching environment).
typeset -U path
path=($^path(N-/))
