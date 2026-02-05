# Quick Reference - New Neovim Config Structure

## Directory Layout

```
lua/
├── config/
│   ├── core/          → options, keymaps, autocommands, user-functions
│   ├── lsp/           → LSP configuration (init.lua)
│   └── ui/            → UI plugins (themes, statusline, etc.)
├── plugins/
│   ├── core/          → blink, treesitter, lspconfig, conform
│   ├── editing/       → autopairs, surround, flash, markdown
│   ├── navigation/    → telescope, oil, git (consolidated)
│   └── specialized/   → avante, copilot, debug, neotest, dadbod
├── user/
│   ├── commands/      → Custom vim commands
│   ├── functions/     → Utility functions
│   └── integrations/  → (Reserved for future)
└── utils/             → Shared utilities (icons)
```

## Quick File Locations

### Core Config
- **Options**: `config/core/options.lua`
- **Keymaps**: `config/core/keymaps.lua`
- **Autocommands**: `config/core/autocommands.lua`

### LSP
- **All LSP config**: `config/lsp/init.lua`
- Add servers in `M.servers = { ... }`
- Modify keymaps in `M.on_attach()`

### Plugins by Category

**Completion & LSP:**
- `plugins/core/blink.lua` - Completion
- `plugins/core/lspconfig.lua` - LSP plugin spec
- `plugins/core/treesitter.lua` - Treesitter plugin spec

**Editing:**
- `plugins/editing/markdown.lua` - All markdown (render-markdown + markview)
- `plugins/editing/autopairs.lua`
- `plugins/editing/surround.lua`
- `plugins/editing/flash.lua`

**Navigation & Git:**
- `plugins/navigation/git.lua` - All git (gitsigns + diffview + octo + blame)
- `plugins/navigation/telescope.lua`
- `plugins/navigation/oil.lua`

**Specialized:**
- `plugins/specialized/avante.lua` - AI
- `plugins/specialized/copilot.lua` - AI
- `plugins/specialized/debug.lua` - DAP
- `plugins/specialized/neotest.lua` - Testing
- `plugins/specialized/dadbod.lua` - Database

**UI:**
- `config/ui/catppuccin.lua` - Theme
- `config/ui/lualine.lua` - Statusline
- `config/ui/snacks.lua` - Snacks.nvim

### User Code
- **Commands**: `user/commands/init.lua`
- **Functions**: `user/functions/*.lua`

## Common Tasks

### Add a New Plugin

1. Decide category (core/editing/navigation/specialized)
2. Create file: `plugins/{category}/my-plugin.lua`
3. Return lazy.nvim spec:
```lua
return {
  'author/plugin-name',
  config = function()
    require('plugin-name').setup {}
  end,
}
```

### Add a New LSP Server

Edit `config/lsp/init.lua`:
```lua
M.servers = {
  -- existing servers...
  
  new_server = {
    settings = {
      -- server settings
    },
  },
}
```

### Add a Custom Command

Edit `user/commands/init.lua`:
```lua
vim.api.nvim_create_user_command('MyCommand', function()
  -- command logic
end, {})
```

### Add a Utility Function

Create `user/functions/my-function.lua`:
```lua
local function my_function()
  -- logic
end

-- Use directly or export
return my_function
```

## Consolidated Files

### Markdown (`plugins/editing/markdown.lua`)
Contains:
- render-markdown.nvim (enabled)
- markview.nvim (disabled)

### Git (`plugins/navigation/git.lua`)
Contains:
- gitsigns.nvim - Git signs in gutter
- diffview.nvim - Diff viewer
- octo.nvim - GitHub integration
- blame.nvim - Git blame

## Import Paths Changed

| Old | New |
|-----|-----|
| `config.icons` | `utils.icons` |
| `config.user_functions` | `config.core.user-functions` |
| `config.options` | `config.core.options` |
| `config.keymaps` | `config.core.keymaps` |
| `config.autocommands` | `config.core.autocommands` |

## Useful Commands

```vim
:Lazy                    " Plugin manager
:Mason                   " LSP/tool installer
:LspInfo                 " LSP status
:checkhealth             " Health check
:Telescope keymaps       " See all keymaps
```

## Troubleshooting

**Plugin not loading?**
- Check it's in correct category directory
- Verify file returns valid lazy.nvim spec
- Check `:Lazy log`

**LSP not working?**
- Check `config/lsp/init.lua`
- Run `:Mason` to verify installation
- Check `:LspInfo`

**Module not found?**
- Check import paths (see table above)
- Verify file exists in new location

## Key Benefits

✅ **Organized** - Logical categories  
✅ **Consolidated** - Related plugins together  
✅ **Maintainable** - Clear structure  
✅ **Scalable** - Easy to extend  
✅ **Documented** - Self-explanatory layout

## Documentation Files

- `STRUCTURE.md` - Detailed structure documentation
- `MIGRATION_GUIDE.md` - Migration details and file mapping
- `REORGANIZATION_SUMMARY.md` - Complete summary of changes
- `QUICK_REFERENCE.md` - This file (quick reference)

## Notes

- Old files still exist but aren't loaded
- All functionality preserved
- No breaking changes to keymaps
- Naming uses hyphens (e.g., `user-functions.lua`)
