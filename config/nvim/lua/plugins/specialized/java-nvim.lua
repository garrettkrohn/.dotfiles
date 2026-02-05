return {
  'nvim-java/nvim-java',
  ft = { 'java' },
  dependencies = {
    'mfussenegger/nvim-dap',
    'nvim-neotest/nvim-nio',
    'rcarriga/nvim-dap-ui',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
  },
  config = function()
    -- Setup nvim-java without automatic DAP - we'll configure manually
    require('java').setup {
      -- Disable automatic DAP to avoid workspace command issues
      java_debug_adapter = {
        enable = false,
      },
      java_test = {
        enable = false,
      },
      jdk = {
        auto_install = false,
      },
      -- Use Java 21 instead of the Mason-installed Java 17
      java_home = '/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home',
    }
  end,
}
