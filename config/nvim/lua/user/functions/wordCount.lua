local M = {}

function M.count_words()
  local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), ' ')
  local word_count = 0
  for _ in string.gmatch(content, '%S+') do
    word_count = word_count + 1
  end
  print('Word count: ' .. word_count)
end

vim.cmd 'command! CountWords lua require("user_functions").count_words()'

vim.keymap.set('n', '<leader>wc', M.count_words, { remap = false, silent = false })

return M
