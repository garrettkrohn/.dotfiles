local M = {}

--- Check if jdtls (Java LSP) is attached and running
local function is_jdtls_attached()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    if client.name == 'jdtls' then
      return true
    end
  end
  return false
end

function M.setup()
  local dap = require 'dap'
  
  -- Check if we're in a Java buffer and jdtls is attached
  if vim.bo.filetype == 'java' and is_jdtls_attached() then
    -- We're good to go, jdtls is attached and adapter should be ready
    dap.continue()
    return
  end
  
  -- Not in a Java buffer or jdtls not attached
  if vim.bo.filetype ~= 'java' then
    vim.notify('Please open a Java file before debugging Java applications.', vim.log.levels.WARN)
    return
  end
  
  -- In a Java buffer but jdtls not attached yet, wait for it
  vim.notify('Waiting for Java LSP to attach...', vim.log.levels.INFO)
  vim.defer_fn(function()
    if is_jdtls_attached() then
      dap.continue()
    else
      vim.notify('Java LSP failed to attach. Check your Java setup.', vim.log.levels.ERROR)
    end
  end, 1000)
end

function M.globalServiceSetup()
  local dap = require 'dap'
  
  if vim.bo.filetype == 'java' and is_jdtls_attached() then
    dap.continue()
    return
  end
  
  if vim.bo.filetype ~= 'java' then
    vim.notify('Please open a Java file before debugging.', vim.log.levels.WARN)
    return
  end
  
  vim.notify('Waiting for Java LSP...', vim.log.levels.INFO)
  vim.defer_fn(function()
    if is_jdtls_attached() then
      dap.continue()
    else
      vim.notify('Java LSP not ready.', vim.log.levels.ERROR)
    end
  end, 1000)
end

vim.cmd 'command! Dap lua require("user_functions.custom_dap").setup()'
return M
