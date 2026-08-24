return {
  'stevearc/conform.nvim',
  event = 'VeryLazy',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local conform = require 'conform'

    conform.setup {
      formatters_by_ft = {
        javascript = { 'prettier_js' },
        typescript = { 'prettier_js' },
        javascriptreact = { 'prettier_js' },
        typescriptreact = { 'prettier_js' },
        svelte = { 'prettier' },
        css = { 'prettier' },
        markdown = { 'injected' }, -- Use Neovim's built-in formatter
        graphql = { 'prettier' },
        lua = { 'stylua' },
        python = { 'isort', 'black' },
      },
      formatters = {
        prettier = {
          prepend_args = { '--tab-width', '4' },
        },
        prettier_js = {
          inherit = 'prettier',
          prepend_args = { '--tab-width', '2' },
        },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>mp', function()
      conform.format {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      }
    end, { desc = 'Format file or range (in visual mode)' })
  end,
}
