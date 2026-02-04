# Migration Guide: Old → New Structure

## Overview

This guide explains how the configuration was reorganized and what changed.

## Before & After Comparison

### Before (Flat Structure)
```
lua/
├── config/
│   ├── autocommands.lua
│   ├── icons.lua
│   ├── keymaps.lua
│   ├── lazy-bootstrap.lua
│   ├── lazy-plugins.lua
│   ├── lsp-setup.lua
│   ├── options.lua
│   ├── snippets.lua
│   ├── treesitter-setup.lua
│   └── user_functions.lua
├── plugins/              # 50+ individual plugin files
│   ├── autopairs.lua
│   ├── avante.lua
│   ├── blink.lua
│   ├── ... (50+ more files)
│   └── yazi.lua
├── user_functions/
│   ├── capitalizeWord.lua
│   ├── custom_dap.lua
│   └── ... (8 files)
└── utils/
    └── icons.lua
```

### After (Organized Structure)
```
lua/
├── config/
│   ├── core/             # ← Core configuration
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   ├── autocommands.lua
│   │   └── user-functions.lua
│   ├── lsp/              # ← Consolidated LSP
│   │   └── init.lua
│   └── ui/               # ← UI plugins
│       ├── catppuccin.lua
│       ├── lualine.lua
│       └── ... (15 files)
├── plugins/
│   ├── core/             # ← Essential plugins
│   │   ├── blink.lua
│   │   ├── treesitter.lua
│   │   └── ... (6 files)
│   ├── editing/          # ← Text editing
│   │   ├── autopairs.lua
│   │   ├── markdown.lua  # ← Consolidated
│   │   └── ... (7 files)
│   ├── navigation/       # ← Navigation & Git
│   │   ├── telescope.lua
│   │   ├── git.lua       # ← Consolidated
│   │   └── ... (9 files)
│   └── specialized/      # ← Domain-specific
│       ├── avante.lua
│       ├── debug.lua
│       └── ... (14 files)
├── user/
│   ├── commands/         # ← Custom commands
│   │   └── init.lua
│   ├── functions/        # ← Utility functions
│   │   └── ... (8 files)
│   └── integrations/     # ← Future use
└── utils/                # ← Shared utilities
    └── icons.lua
```

## File Mapping

### Core Configuration

| Old Location | New Location | Notes |
|-------------|--------------|-------|
| `config/options.lua` | `config/core/options.lua` | No changes |
| `config/keymaps.lua` | `config/core/keymaps.lua` | No changes |
| `config/autocommands.lua` | `config/core/autocommands.lua` | No changes |
| `config/user_functions.lua` | `config/core/user-functions.lua` | Renamed, updated loader |
| `config/icons.lua` | `utils/icons.lua` | Moved to shared utils |

### LSP Configuration

| Old Location | New Location | Notes |
|-------------|--------------|-------|
| `config/lsp-setup.lua` | `config/lsp/init.lua` | Consolidated module |
| `plugins/lspconfig.lua` | `config/lsp/init.lua` | Merged into LSP module |
| Various LSP keymaps | `config/lsp/init.lua` | Centralized in on_attach |

### Plugin Categories

| Old Location | New Location | Category |
|-------------|--------------|----------|
| `plugins/blink.lua` | `plugins/core/blink.lua` | Core |
| `plugins/treesitter.lua` | `plugins/core/treesitter.lua` | Core |
| `plugins/lspconfig.lua` | `plugins/core/lspconfig.lua` | Core |
| `plugins/conform.lua` | `plugins/core/conform.lua` | Core |
| `plugins/autopairs.lua` | `plugins/editing/autopairs.lua` | Editing |
| `plugins/comment.lua` | `plugins/editing/comment.lua` | Editing |
| `plugins/surround.lua` | `plugins/editing/surround.lua` | Editing |
| `plugins/flash.lua` | `plugins/editing/flash.lua` | Editing |
| `plugins/markview.lua` | `plugins/editing/markdown.lua` | Consolidated |
| `plugins/render-markdown.lua` | `plugins/editing/markdown.lua` | Consolidated |
| `plugins/telescope.lua` | `plugins/navigation/telescope.lua` | Navigation |
| `plugins/oil.lua` | `plugins/navigation/oil.lua` | Navigation |
| `plugins/yazi.lua` | `plugins/navigation/yazi.lua` | Navigation |
| `plugins/gitsigns.lua` | `plugins/navigation/git.lua` | Consolidated |
| `plugins/diffview.lua` | `plugins/navigation/git.lua` | Consolidated |
| `plugins/octo.lua` | `plugins/navigation/git.lua` | Consolidated |
| `plugins/blame.lua` | `plugins/navigation/git.lua` | Consolidated |
| `plugins/avante.lua` | `plugins/specialized/avante.lua` | Specialized |
| `plugins/copilot.lua` | `plugins/specialized/copilot.lua` | Specialized |
| `plugins/dadbod.lua` | `plugins/specialized/dadbod.lua` | Specialized |
| `plugins/debug.lua` | `plugins/specialized/debug.lua` | Specialized |
| `plugins/neotest.lua` | `plugins/specialized/neotest.lua` | Specialized |

### UI Plugins

| Old Location | New Location |
|-------------|--------------|
| `plugins/catppuccin.lua` | `config/ui/catppuccin.lua` |
| `plugins/kanagawa.lua` | `config/ui/kanagawa.lua` |
| `plugins/lualine.lua` | `config/ui/lualine.lua` |
| `plugins/snacks.lua` | `config/ui/snacks.lua` |
| `plugins/whichkey.lua` | `config/ui/whichkey.lua` |

### User Code

| Old Location | New Location | Notes |
|-------------|--------------|-------|
| `user_functions/*.lua` | `user/functions/*.lua` | Renamed directory |
| Commands in `config/user_functions.lua` | `user/commands/init.lua` | Extracted |

## Breaking Changes

### Import Paths

If you have custom code that imports from the old structure, update the paths:

**Old:**
```lua
require('config.icons')
require('config.user_functions')
```

**New:**
```lua
require('utils.icons')
require('config.core.user-functions')
```

### LSP Configuration

**Old:** LSP was configured in `plugins/lspconfig.lua`

**New:** LSP is configured via the module:
```lua
require('config.lsp').setup()
```

### Plugin Loading

**Old:** Plugins loaded from flat `plugins/` directory

**New:** Plugins loaded from categorized subdirectories:
```lua
require('lazy').setup {
  { import = 'plugins.core' },
  { import = 'plugins.editing' },
  { import = 'plugins.navigation' },
  { import = 'plugins.specialized' },
  { import = 'config.ui' },
}
```

## What Stayed the Same

- All keymaps remain unchanged
- Plugin configurations are identical
- User functions work the same way
- Lazy.nvim plugin specs format unchanged
- All features and functionality preserved

## Testing the Migration

1. **Backup your old config:**
   ```bash
   cp -r ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Test the new structure:**
   ```bash
   nvim
   ```

3. **Check for errors:**
   - Run `:checkhealth`
   - Check `:Lazy` for plugin status
   - Check `:LspInfo` for LSP status
   - Test your common workflows

4. **Verify plugins load:**
   ```vim
   :Lazy
   ```

5. **Verify LSP works:**
   ```vim
   :LspInfo
   :Mason
   ```

## Rollback Plan

If you encounter issues, you can rollback:

```bash
# Remove new config
rm -rf ~/.config/nvim

# Restore backup
mv ~/.config/nvim.backup ~/.config/nvim
```

## Common Issues & Solutions

### Issue: "Module not found" errors

**Solution:** Check import paths in your custom code. Update to new structure:
- `config.icons` → `utils.icons`
- `config.user_functions` → `config.core.user-functions`

### Issue: Plugins not loading

**Solution:** Verify plugin files are in correct category directories. Run `:Lazy sync`.

### Issue: LSP not working

**Solution:** The LSP configuration is now in `config/lsp/init.lua`. Check that `require('config.lsp').setup()` is called in `init.lua`.

### Issue: Keymaps not working

**Solution:** Keymaps are unchanged. Check `config/core/keymaps.lua` and plugin-specific keymaps.

### Issue: Custom commands missing

**Solution:** Custom commands are now in `user/commands/init.lua`. Verify this file is loaded in `init.lua`.

## Benefits of New Structure

1. **Better Organization** - Logical grouping by function
2. **Easier Navigation** - Find related configs quickly
3. **Reduced Complexity** - Consolidated related plugins
4. **Clearer Separation** - Core vs. user vs. plugins
5. **Scalability** - Easy to add new plugins/features
6. **Maintainability** - Simpler to update and debug
7. **Documentation** - Structure is self-documenting

## Next Steps

After migration:

1. **Familiarize yourself** with the new structure
2. **Read STRUCTURE.md** for detailed documentation
3. **Update any custom scripts** that reference old paths
4. **Consider cleanup** - Remove old plugin files after testing
5. **Customize further** - Add your own categories or modules

## Questions?

- Check `STRUCTURE.md` for detailed documentation
- Review the new `init.lua` for loading order
- Look at consolidated files like `plugins/navigation/git.lua` for examples
- Test incrementally - one category at a time if needed

## Cleanup (Optional)

Once you've verified everything works, you can remove old files:

```bash
cd ~/.config/nvim/lua

# Remove old flat plugin files (after backing up!)
# Only do this after thorough testing!

# The old files are still present but not loaded
# You can keep them as reference or delete them
```

**Note:** The reorganization keeps old files in place initially. They're simply not loaded by the new `init.lua`. This allows for easy rollback if needed.
