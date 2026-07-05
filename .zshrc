export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# ─── Variables de entorno ──────────────────────────────────────────
[ -f "$HOME/.env" ] && source "$HOME/.env"

export EDITOR="nvim"
export PATH="$HOME/.local/share/npm-global/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# ─── Aliases ───────────────────────────────────────────────────────
alias ls="eza --icons"
alias ll="eza -la --icons"
alias lt="eza -T --icons"
alias cat="bat"
alias grep="rg"
alias find="fd"
alias sed="sd"
alias ..="cd .."
alias ...="cd ../.."
alias gs="git status"
alias gc="git commit -m"
alias gp="git push"
alias gl="git log --oneline --graph --all"

# ─── OpenCode PRO shortcuts ───────────────────────────────────────
# ocrp() { opencode run --dir "$1" --agent project-code-reviewer "$2"; }

# ─── Pentesting shorcuts ──────────────────────────────────────────
alias nmap-fast="nmap -T4 -F"
alias nmap-full="nmap -T4 -p- -A"
alias gobuster-dir="gobuster dir -u"
alias rustscan="docker run -it --rm --name rustscan rustscan/rustscan:latest"
