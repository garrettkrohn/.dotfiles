#!/usr/bin/env bash

set -e

echo "🚀 Running post-install setup..."

# ============================================================================
# Secrets Setup
# ============================================================================
echo ""
echo "🔐 Setting up secrets directory..."

SECRETS_DIR="$HOME/dotfiles/config/secrets/scripts"
SECRETS_FILE="$SECRETS_DIR/secret_aliases"
SECRETS_TEMPLATE="$SECRETS_DIR/secret_aliases.example"

if [ ! -f "$SECRETS_FILE" ]; then
    if [ -f "$SECRETS_TEMPLATE" ]; then
        echo "Creating secret_aliases from template..."
        cp "$SECRETS_TEMPLATE" "$SECRETS_FILE"
        echo "✓ Created $SECRETS_FILE"
        echo "  Edit this file to add your private aliases and tokens"
    else
        echo "⚠️  Template not found, creating empty secret_aliases"
        mkdir -p "$SECRETS_DIR"
        touch "$SECRETS_FILE"
    fi
else
    echo "✓ secret_aliases already exists"
fi

# ============================================================================
# Python Packages
# ============================================================================
echo ""
echo "📦 Installing Python packages..."

# QMK CLI for keyboard firmware
if ! command -v qmk &> /dev/null; then
    echo "Installing QMK CLI..."
    python3 -m pip install --user qmk
else
    echo "✓ QMK CLI already installed"
fi

# ============================================================================
# QMK Firmware Setup
# ============================================================================
echo ""
echo "⌨️  Setting up QMK firmware..."

if [ ! -d "$HOME/.config/qmk_firmware" ]; then
    echo "Cloning QMK firmware repository..."
    qmk setup -y -H "$HOME/.config/qmk_firmware"
else
    echo "✓ QMK firmware already exists"
fi

# ============================================================================
# Tmux Plugin Manager
# ============================================================================
echo ""
echo "🖥️  Setting up Tmux plugins..."

if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    echo "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
else
    echo "✓ Tmux Plugin Manager already installed"
fi

# ============================================================================
# Zinit (Zsh Plugin Manager)
# ============================================================================
echo ""
echo "🐚 Setting up Zinit..."

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    echo "Installing Zinit..."
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
else
    echo "✓ Zinit already installed"
fi

# ============================================================================
# Neovim Setup
# ============================================================================
echo ""
echo "📝 Setting up Neovim..."

# Bob (Neovim version manager) - if not installed via brew
if ! command -v bob &> /dev/null; then
    echo "⚠️  Bob not found. Install with: brew install bob"
fi

# Install latest stable Neovim via bob if bob exists
if command -v bob &> /dev/null; then
    echo "Installing latest stable Neovim via bob..."
    bob install stable
    bob use stable
fi

# ============================================================================
# Final Steps
# ============================================================================
echo ""
echo "✅ Post-install complete!"
echo ""
echo "📋 Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Open tmux and press prefix + I to install tmux plugins"
echo "  3. Open Neovim and run :Lazy sync to install plugins"
echo "  4. For QMK keyboard setup, your keymap is symlinked to:"
echo "     ~/.config/qmk_firmware/keyboards/zsa/moonlander/keymaps/moonlander2"
echo "  5. Compile keyboard firmware with: qc (alias for qmk compile)"
echo "  6. Flash keyboard firmware with: qf (alias for qmk flash)"
echo ""
