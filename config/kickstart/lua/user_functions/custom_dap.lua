local M = {}

function M.setup()
  local dap = require 'dap' -- Lazy load here
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
  print 'configuration run'
end

function M.globalServiceSetup()
  local dap = require 'dap' -- Lazy load here too
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
