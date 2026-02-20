return {
  'nvim-java/nvim-java',
  ft = { 'java' },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-dap',
  },
  config = function()
    require('java').setup {
      java_debug_adapter = {
        enable = true,
      },
      java_test = {
        enable = true,
      },
      spring_boot_tools = {
        enable = false,
      },
      jdk = {
        auto_install = true,
      },
    }

    vim.schedule(function()
      vim.lsp.enable 'jdtls'
    end)
  end,
}
