local M = {}

function M.delete_and_paste_uppercase()
  vim.cmd 'normal! diw'

  local word = vim.fn.getreg '"'
  local upper_word = string.upper(word)

  vim.fn.setreg('a', upper_word)

  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_pos[2] - 1 })

  vim.cmd 'normal! "ap'
end

vim.cmd 'command! DeleteAndPasteUppercase lua require("user_functions.capitalizeWord").delete_and_paste_uppercase()'

vim.keymap.set('n', '<leader>u', M.delete_and_paste_uppercase, { remap = true, silent = false })

return M
