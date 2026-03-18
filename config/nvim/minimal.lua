-- Minimal config for dadview (memory leak workaround)
-- Uses new organized structure

require 'config.core.options'

-- Set up paths for isolated environment
local lazypath = vim.fn.stdpath 'data' .. '/lazy-minimal/lazy.nvim'
local lazyvimpath = vim.fn.stdpath 'data' .. '/lazy-minimal/LazyVim'

-- Clone lazy.nvim if not present
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Set up lazy.nvim
require('lazy').setup {
  -- Load plugins from config/nvim/lua/plugins/
  require 'plugins.dadview',
  require 'plugins.blink',
  require 'plugins.lspconfig',
  {
    'catppuccin/nvim',
    enabled = true,
    lazy = false,
    name = 'catppuccin',
    priority = 1000,
    flavour = 'mocha',
    transparent_background = true,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha',
        background = {
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = true,
        show_end_of_buffer = false,
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = 'dark',
          percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = { 'italic' },
          conditionals = { 'italic' },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        custom_highlights = {
          LineNr = { fg = '#f8f8f2' },
        },
        default_integrations = true,
        integrations = {
          blink_cmp = true,
          cmp = true,
          diffview = true,
          gitsigns = true,
          mason = true,
          neotest = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope_color = '',
          },
        },
      }

      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'christoomey/vim-tmux-navigator',
    event = 'BufEnter *',
  },
  require 'plugins.oil',
  require 'plugins.lua-console',
}

require 'config.core.keymaps'
require 'config.core.autocommands'
require 'config.core.user-functions'
