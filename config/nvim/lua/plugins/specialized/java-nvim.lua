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
    require('java').setup {
      -- Enable Java debug adapter
      java_debug_adapter = {
        enable = true,
      },
      java_test = {
        enable = true,
      },
      jdk = {
        -- Enable auto_install to use nvim-java's managed Java installation (Java 25)
        -- This avoids conflicts with system Java installations
        auto_install = true,
      },
      root_markers = {
        'settings.gradle',
        'settings.gradle.kts',
        'pom.xml',
        'build.gradle',
        'mvnw',
        'gradlew',
        'build.gradle.kts',
        '.git',
      },
    }
    
    -- Ensure JDTLS is enabled after nvim-java configures it
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      callback = function()
        -- Enable JDTLS if it's not already running
        local clients = vim.lsp.get_clients({ bufnr = 0, name = 'jdtls' })
        if #clients == 0 then
          vim.lsp.enable('jdtls')
        end
      end,
    })
  end,
}
