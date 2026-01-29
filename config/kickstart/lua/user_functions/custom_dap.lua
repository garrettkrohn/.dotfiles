local M = {}

function M.setup()
  local dap = require 'dap'
  
  -- Check if Java adapter is available
  if not dap.adapters.java then
    vim.notify('Java debug adapter not available. Opening a Java file first...', vim.log.levels.WARN)
    -- Try to load nvim-java
    local ok, java = pcall(require, 'java')
    if ok then
      vim.defer_fn(function()
        if dap.adapters.java then
          dap.continue()
        else
          vim.notify('Failed to load Java adapter. Make sure nvim-java is properly configured.', vim.log.levels.ERROR)
        end
      end, 300)
    else
      vim.notify('nvim-java not found. Install it for Java debugging support.', vim.log.levels.ERROR)
    end
    return
  end
  
  -- Adapter available, start debugging
  dap.continue()
end

function M.globalServiceSetup()
  local dap = require 'dap'
  
  if not dap.adapters.java then
    vim.notify('Java debug adapter not available. Loading...', vim.log.levels.WARN)
    local ok, java = pcall(require, 'java')
    if ok then
      vim.defer_fn(function()
        if dap.adapters.java then
          dap.continue()
        else
          vim.notify('Failed to load Java adapter.', vim.log.levels.ERROR)
        end
      end, 300)
    else
      vim.notify('nvim-java not found.', vim.log.levels.ERROR)
    end
    return
  end
  
  dap.continue()
end

vim.cmd 'command! Dap lua require("user_functions.custom_dap").setup()'
return M
