return {
  lazy = false,
  'echasnovski/mini.comment',
  version = false,
  config = function()
    require('mini.comment').setup()
    vim.cmd [[
      autocmd FileType sql setlocal commentstring=--\ %s
    ]]
  end,
}
