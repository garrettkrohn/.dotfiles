return {
  'nvim-java/nvim-java',
  tag = 'v4.0.4',
  ft = { 'java' },
  jdtls = {
    version = 'v1.43.0',
  },
  opts = {
    java_debug_adapter = {
      enabled = false,
      notifications = {
        dap = true,
      },
    },
  },
  config = function()
    require('java').setup()
    require('lspconfig').jdtls.setup {}
  end,
}
