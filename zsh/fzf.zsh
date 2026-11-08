# FZF configuration, sourced from ~/.profile.
# vim: ft=zsh

# Shell integration: ctrl-t (files), ctrl-r (history), alt-c (cd), ** completion
_cached_init fzf-init fzf fzf --zsh && source "$REPLY"

# Options
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

# Helpers
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# https://github.com/junegunn/fzf/wiki/examples#changing-directory
fcd() {
  local dir
  dir=$(
    find "${1:-.}" -path '*/\.*' -prune -o -type d -print \
      -maxdepth 2 2>/dev/null |
      fzf +m \
        --preview 'eza --tree --level=2 --icons --color=always {} | head -200' \
        --bind 'ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up'
  )
  [[ -n $dir ]] || return 0 # fzf cancelled
  cd "$dir" || return
}

cwd() {
  local dir
  dir=$(
    find \
      -mindepth 1 -maxdepth 1 -type d |
      fzf \
        --preview 'eza --tree --level=1 --icons --color=always {} | head -200' \
        --bind 'ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up'
  )
  [[ -n $dir ]] || return 0 # fzf cancelled
  cd "$dir" || return
}

ccd() {
  local dir
  dir=$(
    project-dirs |
      fzf \
        --preview 'eza --tree --level=1 --icons --color=always {} | head -200' \
        --bind 'ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up'
  )
  [[ -n $dir ]] || return 0 # fzf cancelled
  cd "$dir" || return
}
