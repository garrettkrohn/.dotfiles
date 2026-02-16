# Garrett Krohn's Dotfiles

A comprehensive development environment configuration for macOS, featuring a highly customized Neovim setup, window management, and terminal tooling.

## Quick Start

1. Clone this repository to your home directory:
   ```bash
   cd ~
   git clone <repository-url> dotfiles
   ```

2. Install Homebrew dependencies:
   ```bash
   ./dotfiles/config/scripts/brew_install.sh
   ```

3. Run the installer from your home directory:
   ```bash
   cd ~
   ./dotfiles/install
   ```

**Note:** The dotfiles folder must be in your home directory and named `dotfiles` for the installation to work correctly.

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
- `brew_install.sh` - Install Homebrew packages
- `cursor` - Cursor editor integration
- `cursor-agent` - Cursor AI agent helper
- Various utility scripts

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
