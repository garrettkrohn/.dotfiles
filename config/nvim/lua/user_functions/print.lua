local M = {}

function M.print(object)
  print(vim.inspect(object))
end

vim.cmd 'command! -nargs=1 P lua require("user_functions.print").print(<args>)'

return M
