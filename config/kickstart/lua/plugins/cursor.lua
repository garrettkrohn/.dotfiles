return {
  'waldnzwrld/cursor-agent.nvim',
  lazy = false,
  branch = 'sidebar-instead-of-floating-window',
  commit = 'c56364d655b53db55ad9577c2ae136f13d3871af',
  config = function()
    require('cursor-agent').setup {
      window_mode = 'attached',
      position = 'right',
      width = 0.4,
    }
    vim.keymap.set('n', '<leader>ca', ':CursorAgent<CR>', { desc = 'Cursor Agent: Toggle terminal' })
    vim.keymap.set('v', '<leader>ca', ':CursorAgentSelection<CR>', { desc = 'Cursor Agent: Send selection' })
    vim.keymap.set('n', '<leader>cA', ':CursorAgentBuffer<CR>', { desc = 'Cursor Agent: Send buffer' })
  end,
}
