# FFF.nvim Configuration Fix

## Summary

Fixed the error: `Failed to search files: bad argument #3: error converting Lua nil to usize`

## Problem

The fff.nvim plugin was being called incorrectly from the Snacks dashboard with arguments that the function doesn't accept:

```lua
-- WRONG: find_files() doesn't accept arguments
pcall(fff.find_files, { cwd = vim.fn.getcwd() })
```

## Changes Made

### 1. Fixed `lua/config/ui/snacks.lua`

**Before (Incorrect):**
```lua
local success = pcall(fff.find_files, { cwd = vim.fn.getcwd() })
```

**After (Correct):**
```lua
local success = pcall(fff.find_files)
```

### 2. Updated `lua/plugins/navigation/fff.lua`

**Before:**
```lua
build = 'cargo build --release',
```

**After:**
```lua
build = function()
  -- This will download prebuilt binary or try to use existing rustup toolchain to build from source
  require('fff.download').download_or_build_binary()
end,
```

## Explanation

According to the fff.nvim documentation:

### Available Methods

- `require('fff').find_files()` - Find files in current directory (NO ARGUMENTS)
- `require('fff').find_in_git_root()` - Find files in git repository
- `require('fff').find_files_in_dir(path)` - Find files in a specific directory
- `require('fff').change_indexing_directory(new_path)` - Change base directory

### Key Points

1. **`find_files()` takes no arguments** - It uses the current working directory by default
2. **To search in a specific directory**, use `find_files_in_dir(path)` instead
3. **The build function** should use `require('fff.download').download_or_build_binary()` which will:
   - Try to download a prebuilt binary for your platform
   - Fall back to building from source using rustup if needed

## Additional Notes

### If you need to search in a specific directory

Instead of passing arguments to `find_files()`, use one of these approaches:

```lua
-- Option 1: Use find_files_in_dir
require('fff').find_files_in_dir('/path/to/directory')

-- Option 2: Change the indexing directory first
require('fff').change_indexing_directory('/path/to/directory')
require('fff').find_files()

-- Option 3: Use find_in_git_root for git repositories
require('fff').find_in_git_root()
```

### Rebuilding the binary

If you need to rebuild the fff.nvim binary:

1. In Neovim: `:Lazy build fff.nvim`
2. Or manually: `cd ~/.local/share/nvim/lazy/fff.nvim && cargo build --release`

### Troubleshooting

If fff.nvim still doesn't work:

1. Check health: `:FFFHealth`
2. View logs: `:FFFOpenLog`
3. Ensure Rust is installed: `rustup --version`
4. Rebuild the plugin: `:Lazy build fff.nvim`

## References

- [fff.nvim GitHub](https://github.com/dmtrKovalenko/fff.nvim)
- [fff.nvim Documentation](https://github.com/dmtrKovalenko/fff.nvim/blob/main/README.md)
