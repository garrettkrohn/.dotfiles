# LSP Migration to Neovim 0.11 API

## Summary

This document describes the migration from the deprecated `lspconfig` framework to the new `vim.lsp.config` API introduced in Neovim 0.11.

## Changes Made

### 1. Updated `lua/config/lsp/init.lua`

**Before:**
```lua
local lspconfig = require 'lspconfig'
local capabilities = require('blink.cmp').get_lsp_capabilities()

for server_name, config in pairs(M.servers) do
  local server_config = vim.tbl_deep_extend('force', {
    capabilities = capabilities,
  }, config)
  
  lspconfig[server_name].setup(server_config)
end
```

**After:**
```lua
local capabilities = require('blink.cmp').get_lsp_capabilities()

for server_name, config in pairs(M.servers) do
  local server_config = vim.tbl_deep_extend('force', {
    capabilities = capabilities,
  }, config)
  
  -- Register the LSP server configuration using the new API
  vim.lsp.config[server_name] = server_config
  
  -- Enable the server (this replaces lspconfig[server_name].setup())
  vim.lsp.enable(server_name)
end
```

### 2. Updated `minimal.lua`

Applied the same changes to the minimal configuration for consistency.

### 3. Updated JDTLS Configuration

**Before:**
```lua
server_config.root_dir = function(fname)
  local parent_dir = vim.fn.expand '~/code/platform_work/ENG-131_scanner_dsl_setup/parent'
  if fname:match('^' .. vim.pesc(parent_dir)) then
    return parent_dir
  end
  
  local util = require 'lspconfig.util'
  return util.root_pattern('pom.xml', 'build.gradle', '.git')(fname)
end
```

**After:**
```lua
server_config.root_dir = function(bufnr, on_dir)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local parent_dir = vim.fn.expand '~/code/platform_work/ENG-131_scanner_dsl_setup/parent'
  
  -- Check if file is in the parent directory
  if fname:match('^' .. vim.pesc(parent_dir)) then
    on_dir(parent_dir)
    return
  end

  -- Fallback to standard root markers
  local root = vim.fs.root(bufnr, { 'pom.xml', 'build.gradle', '.git' })
  if root then
    on_dir(root)
  end
end
```

## Key API Changes

### Old API (Deprecated)
- `require('lspconfig')` - The lspconfig framework
- `lspconfig[server_name].setup(config)` - Setup and start a server
- `require('lspconfig.util').root_pattern(...)` - Find project root

### New API (Neovim 0.11+)
- `vim.lsp.config[server_name] = config` - Define server configuration
- `vim.lsp.enable(server_name)` - Enable and start a server
- `vim.fs.root(bufnr, markers)` - Find project root
- `root_dir = function(bufnr, on_dir)` - New signature for root_dir functions

## Benefits

1. **Native API**: No longer depends on external plugin framework
2. **Better Integration**: Tighter integration with Neovim's LSP core
3. **Simplified**: Less abstraction layers
4. **Future-proof**: Aligned with Neovim's direction

## Dependencies

- `nvim-lspconfig` is still required as a dependency for `mason-lspconfig.nvim`
- `mason-lspconfig.nvim` has been updated to work with the new API
- The plugin now automatically calls `vim.lsp.enable()` for installed servers

## Testing

To verify the migration:

1. Start Neovim normally
2. Open a file with an LSP server configured (e.g., `.lua`, `.ts`, `.go`)
3. Check LSP status: `:checkhealth vim.lsp`
4. Verify server is attached: `:lua =vim.lsp.get_clients()`

## References

- `:help vim.lsp.config`
- `:help vim.lsp.enable`
- `:help lsp-config`
- https://github.com/neovim/nvim-lspconfig (for examples and server configurations)
