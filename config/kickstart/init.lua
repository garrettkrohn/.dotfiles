--  _____        __      ___
-- |  __ \       \ \    / (_)
-- | |  | |_ __   \ \  / / _ _ __ ___
-- | |  | | '__|   \ \/ / | | '_ ` _ \
-- | |__| | |_      \  /  | | | | | | |
-- |_____/|_(_)      \/   |_|_| |_| |_|

-- ============================================================================
-- Core Configuration
-- ============================================================================
require 'config.core.options'
require 'config.core.keymaps'
require 'config.core.autocommands'
require 'config.core.user-functions'

-- ============================================================================
-- Bootstrap lazy.nvim
-- ============================================================================
require 'config.lazy-bootstrap'

-- ============================================================================
-- Plugin Management
-- ============================================================================
require('lazy').setup({
  -- Import plugin configurations from organized directories
  { import = 'plugins.core' },
  { import = 'plugins.editing' },
  { import = 'plugins.navigation' },
  { import = 'plugins.specialized' },
  { import = 'config.ui' },
}, {
  defaults = { lazy = true },
  change_detection = {
    enabled = true,
    notify = false,
  },
})

-- ============================================================================
-- LSP Configuration
-- ============================================================================
require('config.lsp').setup()

-- ============================================================================
-- Treesitter Configuration
-- ============================================================================
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'http',
      'lua',
      'python',
      'tsx',
      'javascript',
      'typescript',
      'vimdoc',
      'vim',
      'bash',
      'markdown',
      'markdown_inline',
      'go',
      'properties',
    },
    auto_install = false,
    sync_install = false,
    ignore_install = {},
    modules = {},
    highlight = { enable = true, disable = { 'sql' } },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- ============================================================================
-- User Commands
-- ============================================================================
require 'user.commands'

-- ============================================================================
-- Custom Highlights
-- ============================================================================
vim.cmd [[
    highlight TelescopeBorder guifg=#89b4fa 
    highlight TelescopePromptBorder guifg=#a6e3a1
    highlight TelescopePreviewBorder guifg=#f5c2e7
]]

-- vim: ts=2 sts=2 sw=2 et
