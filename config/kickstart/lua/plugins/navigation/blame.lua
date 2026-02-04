return {
  lazy = true,
  'FabijanZulj/blame.nvim',
  config = function()
    require('blame').setup()
  end,
  cmd = { 'BlameToggle' },
}
