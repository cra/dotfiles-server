#!/bin/bash
# Bootstrap a new server/dev machine from cra/dotfiles-server
# Run on a fresh Ubuntu 22.04+ machine.
set -euo pipefail

REPO_URL="git@github.com:cra/dotfiles-server.git"
BRANCH="trunk"

echo "==> Installing system packages..."
sudo apt update
sudo apt install -y \
    tmux \
    ripgrep \
    fzf \
    zoxide \
    git \
    curl \
    build-essential \
    python3-pip \
    python3-venv

# Helix (from GitHub releases)
if ! command -v hx &>/dev/null; then
    echo "==> Installing helix..."
    HX_VERSION=$(curl -sL https://api.github.com/repos/helix-editor/helix/releases/latest | grep tag_name | cut -d'"' -f4)
    curl -sL "https://github.com/helix-editor/helix/releases/download/${HX_VERSION}/helix-${HX_VERSION}-x86_64-linux.tar.xz" | tar -xJ -C /tmp
    sudo mv "/tmp/helix-${HX_VERSION}-x86_64-linux/hx" /usr/local/bin/
    mkdir -p ~/.config/helix
    mv "/tmp/helix-${HX_VERSION}-x86_64-linux/runtime" ~/.config/helix/
    rm -rf "/tmp/helix-${HX_VERSION}-x86_64-linux"
fi

# Go (from go.dev if not present)
if ! command -v go &>/dev/null; then
    echo "==> Installing Go..."
    GO_VERSION="1.26.1"
    curl -sL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" | sudo tar -C /usr/local -xzf -
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
fi

# Go tools
echo "==> Installing Go tools..."
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/go-delve/delve/cmd/dlv@latest

# uv (Python package manager)
if ! command -v uv &>/dev/null; then
    echo "==> Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi
UV="$HOME/.local/bin/uv"

# Python LSP
echo "==> Installing Python LSP tools..."
$UV tool install python-lsp-server
$UV tool install pyright
$UV tool install ruff

# kubectl
if ! command -v kubectl &>/dev/null; then
    echo "==> Installing kubectl..."
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt update
    sudo apt install -y kubectl
fi

# Docker
if ! command -v docker &>/dev/null; then
    echo "==> Installing Docker..."
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker "$USER"
fi

# just (command runner)
if ! command -v just &>/dev/null; then
    echo "==> Installing just..."
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | sudo bash -s -- --to /usr/local/bin
fi

# --- Deploy dotfiles via bare git repo ---
echo "==> Setting up dotfiles..."
if [ ! -d "$HOME/.dotfiles" ]; then
    git clone --bare "$REPO_URL" "$HOME/.dotfiles"
fi

alias D='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
D config status.showUntrackedFiles no
D checkout "$BRANCH" 2>/dev/null || {
    # Back up conflicting files
    echo "==> Backing up conflicting files to ~/.dotfiles-backup..."
    mkdir -p "$HOME/.dotfiles-backup"
    D checkout "$BRANCH" 2>&1 | grep -E '^\s' | xargs -I{} mv "$HOME/{}" "$HOME/.dotfiles-backup/{}"
    D checkout "$BRANCH"
}

# Ensure dirs exist for configs
mkdir -p ~/.config/helix

echo ""
echo "==> Done! Add the following to your ~/.bashrc if not already there:"
echo ""
echo "  source ~/.local/etc/dotfiles/bashrc_tmux.sh         # first!"
echo "  PS1_ACCENT=\"orange\"  # frost|aurora|orange|purple|red|yellow|teal|white"
echo "  source ~/.local/etc/dotfiles/bashrc_path.sh"
echo "  source ~/.local/etc/dotfiles/bashrc_dotfiles.sh"
echo "  source ~/.local/etc/dotfiles/bashrc_interactive.sh"
echo "  source ~/.local/etc/dotfiles/bashrc_git.sh"
echo "  source ~/.local/etc/dotfiles/bashrc_ps1.sh"
echo ""
echo "Then restart your shell and verify: hx --health go"
