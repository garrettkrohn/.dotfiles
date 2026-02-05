-- Load all user functions from user/functions directory
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath 'config' .. '/lua/user/functions', [[v:val =~ '\.lua$']])) do
  require('user.functions.' .. file:gsub('.lua$', ''))
end
