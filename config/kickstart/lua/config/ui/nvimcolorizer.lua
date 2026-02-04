return {
  'NvChad/nvim-colorizer.lua',
  enabled = false,
  lazy = false,
  config = function()
    require('colorizer').setup {}
  end,
}
