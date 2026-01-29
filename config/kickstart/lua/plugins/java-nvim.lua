return {
  'nvim-java/nvim-java',
  tag = 'v4.0.4',
  -- Load on Java files
  ft = { 'java' },
  lazy = true,
  dependencies = {
    'nvim-java/nvim-java-dap', -- Required for DAP support
  },
  jdtls = {
    version = 'v1.43.0',
  },
  config = function()
    -- This will be called when a Java file is opened
    -- If already setup by debug plugin, this is a no-op
    local ok, java = pcall(require, 'java')
    if ok then
      java.setup {
        java_debug_adapter = {
          enable = true,
        },
        dap = {
          config_overrides = {},
        },
      }
    end
  end,
}
