return {
  lazy = true,
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
  end,
}
