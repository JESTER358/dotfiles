#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/dotfiles"

msg() { echo -e "\033[1;32m==>\033[0m $1"; }
warn() { echo -e "\033[1;33m==>\033[0m $1"; }
err()  { echo -e "\033[1;31m==>\033[0m $1"; }

cd "$DOTFILES"

# ─── 1. Paquetes oficiales ──────────────────────────────────────────
if command -v pacman &>/dev/null; then
  msg "Instalando paquetes oficiales..."
  sudo pacman -S --needed --noconfirm - < pkglist_official_curated.txt 2>/dev/null || true

  # ─── 2. AUR helper (yay) ──────────────────────────────────────────
  if ! command -v yay &>/dev/null; then
    msg "Instalando yay desde AUR..."
    sudo pacman -S --needed --noconfirm base-devel git go
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
  fi

  msg "Instalando paquetes AUR..."
  yay -S --needed --noconfirm - < pkglist_aur_full.txt 2>/dev/null || true

  # ─── 3. Tools para pentesting ─────────────────────────────────────
  msg "Instalando herramientas de pentesting..."
  sudo pacman -S --needed --noconfirm \
    metasploit nmap wireshark-cli gobuster john hydra sqlmap nikto \
    python-scapy python-requests 2>/dev/null || warn "Algunas tools no están en repos, chequeá AUR"
else
  warn "No es Arch Linux — saltando instalación de paquetes"
fi

# ─── 4. Node global tools ──────────────────────────────────────────
if command -v npm &>/dev/null; then
  msg "Instalando OpenCode..."
  npm install -g @opencode/opencode 2>/dev/null || warn "OpenCode npm install falló"
fi

# ─── 5. Binarios externos (engram, gentle-ai) ──────────────────────
# Estos son estáticos, se descargan si no existen
if ! command -v engram &>/dev/null; then
  msg "engram no encontrado — descargalo de https://engram.sh o instala manualmente"
fi

if ! command -v gentle-ai &>/dev/null; then
  msg "gentle-ai no encontrado — descargalo de su release page"
fi

# ─── 6. Symlinks de configuración ──────────────────────────────────
msg "Instalando configuraciones..."
ln -sf "$DOTFILES/.zshrc"         "$HOME/.zshrc"
ln -sf "$DOTFILES/.env"           "$HOME/.env"
ln -sf "$DOTFILES/.config/git"    "$HOME/.config/git"
ln -sf "$DOTFILES/.config/opencode" "$HOME/.config/opencode"
ln -sf "$DOTFILES/.claude"        "$HOME/.claude"

# ─── 7. Claude CLI skills ──────────────────────────────────────────
if [ ! -d "$HOME/.claude/skills" ]; then
  msg "Instalando skills de Claude..."
  mkdir -p "$HOME/.claude/skills"
  cp -r "$DOTFILES/.claude/skills/"* "$HOME/.claude/skills/" 2>/dev/null || true
fi

# ─── 8. Shell ──────────────────────────────────────────────────────
if [ "$SHELL" != "/usr/bin/zsh" ] && command -v zsh &>/dev/null; then
  msg "Cambiando shell a zsh..."
  chsh -s /usr/bin/zsh
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  msg "Instalando Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ─── 9. Plugins de zsh ────────────────────────────────────────────
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# ─── 10. Directorios locales ──────────────────────────────────────
mkdir -p "$HOME/.local/share/npm-global/bin"

msg ""
msg "╔══════════════════════════════════════════════╗"
msg "║  DOTFILES INSTALADOS                         ║"
msg "║  Recordá crear ~/.env con tus API keys:      ║"
msg "║    GEMINI_API_KEY                            ║"
msg "║    CLAUDE_CODE_OAUTH_TOKEN                   ║"
msg "║    GITHUB_TOKEN                              ║"
msg "╚══════════════════════════════════════════════╝"
