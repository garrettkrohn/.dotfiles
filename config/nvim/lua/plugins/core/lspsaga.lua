return {
  'nvimdev/lspsaga.nvim',
  enabled = false,
  config = function()
    require('lspsaga').setup {
      lightbulb = {
        enable = false,
        virtual_text = false,
      },
    }
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  event = 'BufEnter *',
}
