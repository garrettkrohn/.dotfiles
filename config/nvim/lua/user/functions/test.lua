local M = {}

function M.test()
  print 'hello world'
end

vim.cmd 'command! Test lua require("user_functions.test").test()'

vim.keymap.set('n', '<leader>te', M.test, { remap = true, silent = false })

return M
