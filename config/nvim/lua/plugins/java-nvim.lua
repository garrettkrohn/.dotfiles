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
        auto_install = false,
      },
      -- Use existing Java installation
      java_executable = '/Users/gkrohn/Library/Java/JavaVirtualMachines/ms-21.0.10/Contents/Home/bin/java',
    }

    vim.schedule(function()
      vim.lsp.enable 'jdtls'
    end)
  end,
}
