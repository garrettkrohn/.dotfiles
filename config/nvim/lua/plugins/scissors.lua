return {
  'chrisgrieser/nvim-scissors',
  enabled = false,
  dependencies = 'nvim-telescope/telescope.nvim', -- optional
  opts = { snippetDir = vim.fn.stdpath 'data' .. '/lazy/friendly-snippets' },
}
