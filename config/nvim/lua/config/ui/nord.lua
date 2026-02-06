return {
  enabled = false,
  lazy = false,
  'shaunsingh/nord.nvim',
  config = function()
    -- Example config in lua
    vim.g.nord_contrast = false
    vim.g.nord_borders = false
    vim.g.nord_disable_background = true
    vim.g.nord_italic = false
    vim.g.nord_uniform_diff_background = true
    vim.g.nord_bold = false

    -- Load the colorscheme
    require('nord').set()
  end,
}
