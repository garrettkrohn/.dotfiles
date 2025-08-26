local M = {}
local dap = require 'dap'

function M.setup()
  dap.configurations.java = {
    {
      args = '',
      mainClass = 'com.netspi.platform.Application',
      name = 'application -> com.netspi.platform.Application',
      projectName = 'application',
      request = 'attach',
      hostname = 'localhost',
      port = 5005,
      type = 'java',
      vmArgs = '-Dspring.profiles.active=local',
    },
  }

  -- dap.adapters.java = {
  --   type = 'executable',
  --   command = '~/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-0.53.0.jar',
  --   args = {},
  -- }

  dap.set_log_level 'TRACE'
  print 'configuration run'
end

function M.globalServiceSetup()
  dap.configurations.java = {
    {
      args = '',
      mainClass = 'com.netspi.platform.Application',
      name = 'application -> com.netspi.platform.Application',
      projectName = 'application',
      request = 'attach',
      hostname = 'localhost',
      port = 5005,
      type = 'java',
      vmArgs = '-Dspring.profiles.active=local',
    },
  }
  dap.set_log_level 'TRACE'
end

vim.cmd 'command! Dap lua require("user_functions.custom_dap").setup()'

return M
