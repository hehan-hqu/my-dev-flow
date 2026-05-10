#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

backup_file() {
    local src="$1"
    if [[ -e "$src" && ! -L "$src" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$src" "$BACKUP_DIR/"
        info "Backed up: $src -> $BACKUP_DIR/"
    fi
}

create_link() {
    local target="$1"
    local link="$2"

    if [[ -L "$link" ]]; then
        local current
        current="$(readlink "$link")"
        if [[ "$current" == "$target" ]]; then
            info "Already linked: $link -> $target"
            return
        fi
        backup_file "$link"
    elif [[ -e "$link" ]]; then
        backup_file "$link"
    fi

    ln -sf "$target" "$link"
    info "Linked: $link -> $target"
}

# --- Ghostty ---
info "Setting up Ghostty..."
mkdir -p "$HOME/.config/ghostty"
create_link "$REPO_DIR/ghostty/config" "$HOME/.config/ghostty/config"

# --- Zsh ---
info "Setting up Zsh..."
backup_file "$HOME/.zshrc"
create_link "$REPO_DIR/zsh/zshrc" "$HOME/.zshrc"

# Proxy env
if [[ ! -f "$HOME/.config/proxy.env" ]]; then
    mkdir -p "$HOME/.config"
    cp "$REPO_DIR/zsh/proxy.env.example" "$HOME/.config/proxy.env"
    warn "Created proxy.env from template - edit $HOME/.config/proxy.env with your proxy settings"
fi

# --- Oh-My-Zsh + plugins ---
info "Setting up Oh-My-Zsh..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    info "Installed Oh-My-Zsh"
else
    info "Oh-My-Zsh already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-syntax-highlighting
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    info "Installed zsh-syntax-highlighting"
fi

# zsh-autosuggestions
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    info "Installed zsh-autosuggestions"
fi

# --- Zoxide ---
info "Setting up Zoxide..."
if ! command -v zoxide &>/dev/null; then
    info "Installing Zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    info "Installed Zoxide"
else
    info "Zoxide already installed"
fi

# --- Yazi ---
info "Setting up Yazi..."
mkdir -p "$HOME/.config/yazi"
create_link "$REPO_DIR/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"
create_link "$REPO_DIR/yazi/keymap.toml" "$HOME/.config/yazi/keymap.toml"
create_link "$REPO_DIR/yazi/theme.toml" "$HOME/.config/yazi/theme.toml"
create_link "$REPO_DIR/yazi/package.toml" "$HOME/.config/yazi/package.toml"

# --- Claude Code (手动配置) ---
info "Claude Code 配置请参考: $REPO_DIR/claude-code/README.md"
info "  - 密钥管理: cc-switch (brew install --cask cc-switch)"
info "  - Token 优化: rtk (https://github.com/rtk-ai/rtk)"
info "  - 插件安装: 见 claude-code/README.md"

# --- Done ---
echo ""
info "Setup complete!"
if [[ -d "$BACKUP_DIR" ]]; then
    warn "Backups saved to: $BACKUP_DIR"
fi
echo ""
echo "Next steps:"
echo "  1. Edit ~/.config/proxy.env with your proxy settings"
echo "  2. Edit ~/Code/my-dev-flow/zsh/zshrc and set DEFAULT_USER"
echo "  3. Follow claude-code/README.md to set up Claude Code"
echo "  4. Restart your shell: exec zsh"
