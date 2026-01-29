return {
  'nvim-java/nvim-java',
  -- Load eagerly so it's available when lspconfig sets up jdtls
  lazy = false,
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
    }
  end,
}
