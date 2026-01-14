-- load user functions
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath 'config' .. '/lua/user_functions', [[v:val =~ '\.lua$']])) do
  require('user_functions.' .. file:gsub('.lua$', ''))
end

vim.api.nvim_create_user_command('MyTodos', function()
  local author = vim.fn.system('git config user.name'):gsub('\n', '')
  local cmd = string.format(
    [[
    git grep -n "TODO:" | while IFS=: read -r file line content; do
      if git blame -L $line,$line "$file" 2>/dev/null | grep -q "%s"; then
        echo "$file:$line:$content"
      fi
    done
  ]],
    author
  )

  local output = vim.fn.system(cmd)
  vim.fn.setqflist({}, 'r', {
    title = 'My TODOs',
    lines = vim.split(output, '\n'),
  })
  vim.cmd 'copen'
end, {})
