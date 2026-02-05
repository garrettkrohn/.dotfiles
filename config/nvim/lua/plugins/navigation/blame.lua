return {
  lazy = true,
  event = 'VeryLazy',
  'FabijanZulj/blame.nvim',
  config = function()
    require('blame').setup()
  end,
  cmd = { 'BlameToggle' },
}
