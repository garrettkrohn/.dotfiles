--  _____        __      ___
-- |  __ \       \ \    / (_)
-- | |  | |_ __   \ \  / / _ _ __ ___
-- | |  | | '__|   \ \/ / | | '_ ` _ \
-- | |__| | |_      \  /  | | | | | | |
-- |_____/|_(_)      \/   |_|_| |_| |_|

-- ============================================================================
-- Core Configuration (minimal - before plugins load)
-- ============================================================================
require 'config.core.options'

-- ============================================================================
-- Bootstrap lazy.nvim
-- ============================================================================
require 'config.core.lazy-bootstrap'

-- ============================================================================
-- Plugin Management
-- ============================================================================
require('lazy').setup({
  -- Import plugin configurations
  { import = 'plugins' },
  { import = 'config.ui' },
}, {
  defaults = { lazy = true },
  change_detection = {
    enabled = true,
    notify = false,
  },
})

-- ============================================================================
-- Core Configuration (after plugins load)
-- ============================================================================
require 'config.core.keymaps'
require 'config.core.autocommands'
require 'config.core.user-functions'

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
