return {
  lazy = true,
  enabled = true,
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles' },
  config = function()
    local actions = require 'diffview.actions'
    require('diffview').setup {
      file_panel = {
        listing_style = 'list', -- or "list"
        position = 'bottom', -- "left", "right", "top", "bottom"
        width = 35, -- width for left/right
        height = 10, -- height for top/bottom
      },
      keymaps = {
        view = {
          -- Navigate to next/previous file
          { 'n', ']q', actions.select_next_entry, { desc = 'Next file' } },
          { 'n', '[q', actions.select_prev_entry, { desc = 'Previous file' } },
        },
        file_panel = {
          { 'n', ']q', actions.select_next_entry, { desc = 'Next file' } },
          { 'n', '[q', actions.select_prev_entry, { desc = 'Previous file' } },
        },
      },
    }
    -- Make diff backgrounds transparent
    -- Option 1: Remove background, keep colored foreground (most "transparent")
    vim.api.nvim_set_hl(0, 'DiffAdd', { bg = 'NONE', fg = '#a6e3a1', blend = 95 }) -- or your theme's green
    vim.api.nvim_set_hl(0, 'DiffDelete', { bg = 'NONE', fg = '#f38ba8', blend = 95 }) -- or your theme's red

    -- Option 2: Use more subtle background colors (adjust the hex values to your preference)
    vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#1a2a1a', blend = 95 }) -- very dark green
    vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#2a1a1a', blend = 95 }) -- very dark red
  end,
}
