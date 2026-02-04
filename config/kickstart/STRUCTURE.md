# Neovim Configuration Structure

This document describes the reorganized structure of the Neovim configuration.

## Directory Structure

```
lua/
├── config/
│   ├── core/              # Basic options, keymaps, autocommands
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   ├── autocommands.lua
│   │   └── user-functions.lua
│   ├── lsp/               # Consolidated LSP configuration
│   │   └── init.lua
│   └── ui/                # Theme, statusline, notifications
│       ├── catppuccin.lua
│       ├── kanagawa.lua
│       ├── nord.lua
│       ├── lualine.lua
│       ├── incline.lua
│       ├── dropbar.lua
│       ├── snacks.lua
│       ├── webdevicons.lua
│       ├── nvimcolorizer.lua
│       ├── todocomments.lua
│       ├── fringeMode.lua
│       ├── whichkey.lua
│       ├── key-analyzer.lua
│       ├── vimtmuxnavigator.lua
│       └── fastaction.lua
├── plugins/
│   ├── core/              # Completion, treesitter, LSP
│   │   ├── blink.lua
│   │   ├── treesitter.lua
│   │   ├── lspconfig.lua
│   │   ├── lspkind.lua
│   │   ├── lspsaga.lua
│   │   └── conform.lua
│   ├── editing/           # Surround, autopairs, comments
│   │   ├── autopairs.lua
│   │   ├── comment.lua
│   │   ├── mini-comment.lua
│   │   ├── surround.lua
│   │   ├── flash.lua
│   │   ├── scissors.lua
│   │   └── markdown.lua   # Consolidated markdown plugins
│   ├── navigation/        # Telescope, file explorer, git
│   │   ├── telescope.lua
│   │   ├── fzflua.lua
│   │   ├── oil.lua
│   │   ├── nvimtree.lua
│   │   ├── yazi.lua
│   │   ├── fff.lua
│   │   ├── filenav.lua
│   │   ├── harpoon.lua
│   │   └── git.lua        # Consolidated git plugins
│   └── specialized/       # AI, testing, database
│       ├── avante.lua
│       ├── copilot.lua
│       ├── cursor.lua
│       ├── dadbod.lua
│       ├── new-db-ui.lua
│       ├── debug.lua
│       ├── neotest.lua
│       ├── vimtest.lua
│       ├── rest.lua
│       ├── hurl.lua
│       ├── pyrun.lua
│       ├── venv-selector.lua
│       ├── java-nvim.lua
│       └── uppercase-sql.lua
├── user/
│   ├── commands/          # Custom commands
│   │   └── init.lua
│   ├── functions/         # Utility functions
│   │   ├── capitalizeWord.lua
│   │   ├── custom_dap.lua
│   │   ├── highlightLowercaseSqlKeywords.lua
│   │   ├── print.lua
│   │   ├── save.lua
│   │   ├── share.lua
│   │   ├── test.lua
│   │   └── wordCount.lua
│   └── integrations/      # Complex integrations (future use)
└── utils/                 # Shared utilities
    └── icons.lua

```

## Key Improvements

### 1. Consolidated LSP Configuration

All LSP configuration is now in a single module at `config/lsp/init.lua`:

```lua
-- Usage in init.lua
require('config.lsp').setup()
```

**Benefits:**
- Single source of truth for LSP servers
- Centralized keymaps and on_attach logic
- Easy to add/remove language servers
- Consistent configuration across all servers

### 2. Organized Plugin Categories

Plugins are now organized by function:

- **core**: Essential plugins (completion, treesitter, LSP)
- **editing**: Text manipulation plugins
- **navigation**: File/project navigation and git
- **specialized**: Domain-specific tools (AI, testing, databases)

**Benefits:**
- Easy to find related plugins
- Clear separation of concerns
- Simpler to enable/disable entire categories
- Better lazy loading organization

### 3. Consolidated Related Plugins

Multiple related plugins are now in single files:

- `plugins/editing/markdown.lua` - All markdown plugins
- `plugins/navigation/git.lua` - All git-related plugins (gitsigns, diffview, octo, blame)

**Benefits:**
- Reduced file count
- Related configurations in one place
- Easier to manage dependencies between related plugins

### 4. Centralized User Code

User-specific code is now organized under `user/`:

- `user/commands/` - Custom vim commands
- `user/functions/` - Utility functions
- `user/integrations/` - Complex integrations (reserved for future use)

**Benefits:**
- Clear separation of user code from plugin config
- Easy to share or backup custom functionality
- Modular and maintainable

### 5. Shared Utilities

Common utilities are in `utils/`:

- `utils/icons.lua` - Icon definitions used across configs

**Benefits:**
- DRY principle - no duplication
- Single place to update shared resources
- Easy to extend with more utilities

## Loading Order

The new `init.lua` loads configuration in this order:

1. **Core Configuration** - Options, keymaps, autocommands
2. **Bootstrap lazy.nvim** - Plugin manager setup
3. **Plugin Management** - Load all plugin specs
4. **LSP Configuration** - Setup language servers
5. **Treesitter Configuration** - Syntax highlighting
6. **User Commands** - Custom commands

## Migration from Old Structure

The old structure had:
- Flat `config/` directory
- Flat `plugins/` directory with 50+ files
- Mixed concerns in single files

The new structure provides:
- Hierarchical organization
- Logical grouping
- Consolidated related functionality
- Clear separation of concerns

## Adding New Plugins

### Core Plugin (LSP, completion, etc.)
```lua
-- lua/plugins/core/my-plugin.lua
return {
  'author/plugin-name',
  -- config
}
```

### Editing Plugin
```lua
-- lua/plugins/editing/my-plugin.lua
return {
  'author/plugin-name',
  -- config
}
```

### Navigation Plugin
```lua
-- lua/plugins/navigation/my-plugin.lua
return {
  'author/plugin-name',
  -- config
}
```

### Specialized Plugin
```lua
-- lua/plugins/specialized/my-plugin.lua
return {
  'author/plugin-name',
  -- config
}
```

## Adding New LSP Server

Edit `lua/config/lsp/init.lua`:

```lua
M.servers = {
  -- ... existing servers
  
  new_server = {
    -- server-specific config
    settings = {
      -- server settings
    },
  },
}
```

## Adding Custom Commands

Edit `lua/user/commands/init.lua`:

```lua
vim.api.nvim_create_user_command('MyCommand', function()
  -- command logic
end, {})
```

## Adding Utility Functions

Create a new file in `lua/user/functions/`:

```lua
-- lua/user/functions/my-function.lua
local function my_function()
  -- function logic
end

-- Export or use directly
return my_function
```

The function will be automatically loaded by `config/core/user-functions.lua`.

## Naming Conventions

- Use **hyphens** for multi-word file names (e.g., `user-functions.lua`)
- Use **lowercase** for directory names
- Use **descriptive names** that indicate purpose
- Group related files in subdirectories

## Best Practices

1. **Keep plugins lazy-loaded** when possible
2. **Consolidate related plugins** into single files
3. **Use the LSP module** for all language server config
4. **Put user-specific code** in `user/` directory
5. **Share utilities** via `utils/` directory
6. **Document complex configurations** with comments
7. **Use consistent formatting** (stylua)

## Troubleshooting

### Plugin not loading
- Check if it's in the correct category directory
- Verify the file returns a valid lazy.nvim spec
- Check lazy.nvim logs: `:Lazy log`

### LSP not working
- Check `config/lsp/init.lua` for server configuration
- Verify Mason has installed the server: `:Mason`
- Check LSP logs: `:LspInfo`

### Keymap conflicts
- Check `config/core/keymaps.lua` for global keymaps
- Check plugin configs for plugin-specific keymaps
- Use `:Telescope keymaps` to see all active keymaps

## Future Enhancements

Potential improvements to consider:

1. **Keymap Management System** - Centralized, discoverable keymap system
2. **Profile System** - Different configs for different use cases
3. **Module System** - More granular LSP configuration modules
4. **Plugin Presets** - Predefined plugin combinations for different workflows
5. **Auto-documentation** - Generate keymap cheatsheets automatically
