return {
  'nvim-java/nvim-java',
  -- Load eagerly so it's available when lspconfig sets up jdtls
  lazy = false,
  config = function()
    -- Setup nvim-java WITHOUT automatic DAP - we'll configure it manually
    require('java').setup {
      -- Completely disable automatic DAP setup to avoid repeated errors
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
