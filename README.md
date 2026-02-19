# Garrett Krohn's Dotfiles

A comprehensive development environment configuration for macOS, featuring a highly customized Neovim setup, window management, and terminal tooling.

## Setup Guide for New Machine

Follow these steps in order to set up your dotfiles on a new machine:

1. **Install Homebrew**
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Clone dotfiles repository**
   ```bash
   cd ~
   git clone https://github.com/garrettkrohn/.dotfiles.git dotfiles
   ```

3. **Install Homebrew packages**
   ```bash
   cd ~/dotfiles
   brew bundle install
   ```

4. **Run dotbot installer**
   ```bash
   ./install
   ```

5. **Run post-install script**
   ```bash
   ./post-install.sh
   ```
   This installs: QMK CLI, QMK firmware, Tmux Plugin Manager, Zinit, Bob (Neovim version manager), and creates a secrets file template

6. **Configure macOS defaults (optional but recommended)**
   ```bash
   ./config/scripts/macos-defaults.sh
   ```

7. **Add your secrets (optional)**
   ```bash
   nvim ~/dotfiles/config/secrets/scripts/secret_aliases
   ```
   Add your private aliases, API tokens, and environment variables to this file.

8. **Generate/Transfer SSH Keys**
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   # Add to GitHub/GitLab/etc.
   ```

9. **Sign in to services**
   - GitHub CLI: `gh auth login`
   - AWS CLI: `aws configure` (if needed)
   - Docker Hub: Open Docker Desktop and sign in
   - NPM registry: `npm login` (if using private packages)

10. **Configure and start services**
    ```bash
    # Start borders (window borders)
    brew services start borders
    
    # Start PostgreSQL (if needed)
    brew services start postgresql@15
    ```

11. **Grant permissions to applications**
    - Aerospace: System Settings > Privacy & Security > Accessibility
    - WezTerm/Alacritty: System Settings > Privacy & Security > Accessibility (if needed)

12. **Install application-specific plugins**
    - **Tmux**: Open tmux and press `prefix + I` to install TPM plugins
    - **Neovim**: Run `nvim` then `:Lazy sync` and `:checkhealth`

13. **Configure Node.js**
    ```bash
    # Create NVM directory
    mkdir ~/.nvm
    
    # Install and set default Node version
    fnm install 18.16.0
    fnm default 18.16.0
    ```

14. **Configure Python**
    ```bash
    # Set default Python version
    pyenv global 3.13.0  # or your preferred version
    ```

15. **Restart shell or reboot**
    ```bash
    # Restart shell
    source ~/.zshrc
    
    # Or reboot for all changes to take effect
    sudo reboot
    ```

**Note:** The dotfiles folder must be in your home directory and named `dotfiles` for the installation to work correctly.

For detailed troubleshooting and additional manual steps, see `MIGRATION_CHECKLIST.md` and `MIGRATION_CHECKLIST_ADDITIONAL.md`.

## What's Included

### Core Tools
- **Neovim**: Highly customized IDE-like experience with 40+ plugins
- **Tmux**: Terminal multiplexer with custom configuration
- **Zsh**: Shell with Zinit plugin manager
- **Starship**: Fast, customizable prompt
- **Yazi**: Terminal file manager
- **Alacritty/WezTerm**: Terminal emulators

### Window Management
- **Aerospace**: Tiling window manager configuration
- **Yabai**: Alternative window manager (legacy)
- **SKHD**: Hotkey daemon for macOS

### Development Tools
- **Git**: Enhanced with gh-dash, gitsigns, and octo.nvim
- **Database**: PostgreSQL tools with DadView
- **API Testing**: Kulala and Hurl for HTTP requests
- **Debugging**: Full DAP setup for multiple languages

## Neovim Plugins

### Core LSP & Completion
- **blink.cmp** - Fast, extensible completion engine with LSP, snippets, and custom sources
- **lspconfig** - LSP configuration for multiple languages with Mason integration
- **lspkind** - VS Code-like icons for autocompletion
- **lspsaga** - Enhanced LSP UI (disabled by default)
- **conform.nvim** - Code formatting with support for Prettier, Stylua, Black, and more
- **treesitter** - Syntax highlighting and code understanding

### Navigation & File Management
- **telescope.nvim** - Fuzzy finder for files, buffers, grep, and more
- **oil.nvim** - File explorer that lets you edit your filesystem like a buffer
- **yazi.nvim** - Integration with Yazi terminal file manager
- **fff.nvim** - Fast file finder with fuzzy search
- **fzf-lua** - Alternative fuzzy finder (disabled by default)
- **harpoon** - Quick file navigation (disabled by default)
- **nvim-tree** - File explorer tree view (disabled by default)
- **filenav.nvim** - Navigate between recently opened files

### Git Integration
- **gitsigns.nvim** - Git decorations in the gutter with hunk operations
- **diffview.nvim** - Enhanced diff view for reviewing changes
- **octo.nvim** - GitHub integration for issues and pull requests
- **blame.nvim** - Git blame annotations

### Editing & Text Manipulation
- **flash.nvim** - Navigate code with search labels
- **nvim-surround** - Add, change, and delete surrounding characters
- **nvim-autopairs** - Automatic bracket and quote pairing
- **mini.comment** - Fast and simple commenting
- **scissors** - Snippet management (disabled by default)
- **markdown** - Enhanced markdown rendering with render-markdown.nvim

### AI & Code Assistance
- **99** - ThePrimeagen's AI code assistant
- **cursor-agent.nvim** - Cursor AI integration in Neovim
- **copilot** - GitHub Copilot integration (disabled by default)
- **avante.nvim** - AI-powered code assistant (disabled by default)

### Database & API Tools
- **dadview.nvim** - Modern database UI for PostgreSQL
- **dadbod** - Database interface (disabled, replaced by dadview)
- **kulala.nvim** - REST client for HTTP files
- **hurl.nvim** - Run Hurl files for API testing
- **rest.nvim** - Alternative REST client (disabled by default)
- **uppercase-sql** - Automatically uppercase SQL keywords

### Testing & Debugging
- **nvim-dap** - Debug Adapter Protocol client with UI
- **neotest** - Testing framework with adapters for Jest, Python, and Java
- **vimtest** - Vim-test integration
- **pyrun.nvim** - Quick Python script execution

### Language-Specific
- **java-nvim** - Java development with JDTLS integration
- **venv-selector** - Python virtual environment selector (disabled by default)

### Utilities
- **lua-console.nvim** - Interactive Lua REPL for Neovim development
- **lazydev.nvim** - Better Lua development for Neovim config

## Key Features

### Neovim Configuration
- Lazy-loaded plugins for fast startup
- Comprehensive LSP support for multiple languages
- Integrated debugging with DAP
- Git workflow integration
- Database management from within Neovim
- REST API testing capabilities
- AI-powered code assistance

### Terminal & Shell
- Zinit plugin manager for fast Zsh loading
- Custom aliases and functions
- Starship prompt with Git integration
- Tmux with custom key bindings

### Window Management
- Aerospace tiling window manager
- Custom keyboard shortcuts via SKHD
- Multi-monitor support

## Customization

### Neovim
The Neovim configuration is located in `config/nvim/`. Key files:
- `init.lua` - Main configuration entry point
- `lua/config/` - Core settings, keymaps, and autocommands
- `lua/plugins/` - All plugin configurations (now flattened)
- `lua/config/lsp/` - LSP server configurations

### Shell
- `config/zshrc` - Zsh configuration
- `config/aliases` - Custom shell aliases
- `config/starship.toml` - Prompt configuration

### Window Management
- `config/aerospace.toml` - Aerospace configuration
- `config/skhd` - Keyboard shortcuts

## Scripts

Located in `config/scripts/`:
- `macos-defaults.sh` - Configure macOS system preferences (keyboard, Finder, Dock, etc.)
- `bootstrap.sh` - Bootstrap database with user info
- `cursor` - Cursor editor integration
- `cursor-agent` - Cursor AI agent helper
- Various build and development utility scripts

## Keyboard Configuration

Custom ZSA Moonlander keyboard layouts in `config/keyboards/moonlander2/`

## Requirements

- macOS (Darwin)
- Homebrew
- Git
- Neovim 0.10+
- Node.js (for some LSP servers)
- Python 3 (for some plugins)
- Rust (for some tools)

## Troubleshooting

### Neovim Issues
- Run `:checkhealth` in Neovim to diagnose problems
- Check LSP status with `:LspInfo`
- View lazy.nvim status with `:Lazy`

### Installation Issues
- Ensure the dotfiles folder is in `~/dotfiles`
- Make sure all Homebrew packages are installed
- Check file permissions on scripts

## License

Personal dotfiles - use at your own risk and customize to your needs.

## Credits

Built with inspiration from the Neovim and dotfiles communities. Special thanks to all plugin authors.
