# Diffview Configuration Migration

## Summary

Fixed deprecation warning: `'file_panel.{position|width|height}' has been deprecated.`

## Changes Made

### 1. Updated `lua/plugins/navigation/git.lua`

**Before (Deprecated):**
```lua
file_panel = {
  listing_style = 'list',
  position = 'bottom',
  width = 35,
  height = 10,
},
```

**After (New Format):**
```lua
file_panel = {
  listing_style = 'list',
  win_config = {
    position = 'bottom',
    width = 35,
    height = 10,
  },
},
```

### 2. Disabled Duplicate Configuration

Disabled the standalone `lua/plugins/navigation/diffview.lua` since the configuration in `git.lua` is being used. This prevents plugin conflicts and duplicate setup calls.

## Migration Details

The diffview plugin changed its configuration structure to nest window-related settings under `win_config`. This provides better organization and consistency with other Neovim window configuration patterns.

### Old Structure (Deprecated)
- `file_panel.position` - Direct property
- `file_panel.width` - Direct property  
- `file_panel.height` - Direct property

### New Structure
- `file_panel.win_config.position` - Nested under win_config
- `file_panel.win_config.width` - Nested under win_config
- `file_panel.win_config.height` - Nested under win_config

## Additional Notes

The `win_config` table can also include:
- `win_opts` - Additional window options to pass to `nvim_open_win()`

This change applies to:
- `file_panel.win_config`
- `file_history_panel.win_config`
- `commit_log_panel.win_config`

## References

- [Diffview.nvim Documentation](https://github.com/sindrets/diffview.nvim)
- See `:h diffview-config-win_config` for more details
