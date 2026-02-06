return {
  'stevearc/oil.nvim',
  lazy = false,
  keys = {
    { '<leader><leader>', ':Oil<CR>', desc = 'Toggle oil' },
  },
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    show_hidden = true,
  },
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if prefer nvim-web-devicons
}
