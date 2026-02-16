return {
  lazy = false,
  enabled = false,
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- calling `setup` is optional for customization
    require('fzf-lua').setup {
      keymap = {
        fzf = {
          ['ctrl-q'] = 'select-all+accept',
        },
      },
    }
  end,
}
