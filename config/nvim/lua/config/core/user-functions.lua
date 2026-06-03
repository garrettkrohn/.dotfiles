-- Load all user functions from user/functions directory
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath 'config' .. '/lua/user/functions', [[v:val =~ '\.lua$']])) do
  require('user.functions.' .. file:gsub('.lua$', ''))
end

vim.api.nvim_create_user_command('JdtlsClearCache', function()
  vim.lsp.buf.execute_command { command = 'java.clean.workspace' }
  vim.notify('jdtls workspace cleaned - restart LSP with :LspRestart', vim.log.levels.INFO)
end, {})
