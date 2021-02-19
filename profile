# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Docker format
export FORMAT="ID\t{{.ID}}\nNAME\t{{.Names}}\nIMAGE\t{{.Image}}\nPORTS\t{{.Ports}}\nCOMMAND\t{{.Command}}\nCREATED\t{{.CreatedAt}}\nSTATUS\t{{.Status}}\n"

# Alias
alias python=python3
alias pip=pip3
alias dps="docker ps"
alias dc=docker-compose
alias dcud="docker-compose up -d"
alias dcu="docker-compose up"
alias dcd="docker-compose down"
alias dvols="docker volume ls"
alias dnets="docker network ls"
alias dimgs="docker image ls"
alias dclf="docker-compose logs -f"
alias rmnm="find . -name "node_modules" -type d -prune -exec rm -rf '{}' +"
