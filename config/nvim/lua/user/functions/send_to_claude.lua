local function send_to_claude()
  local relative_path = vim.fn.expand("%:.")
  local context

  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '\22' then
    local save_reg = vim.fn.getreg('"')
    local save_regtype = vim.fn.getregtype('"')

    vim.cmd('normal! "xy')
    local selection = vim.fn.getreg('x')

    vim.fn.setreg('"', save_reg, save_regtype)

    context = string.format("File: %s\n```\n%s\n```\n\n", relative_path, selection)
  else
    context = string.format("File: %s\n\n", relative_path)
  end

  local question = vim.fn.input("Ask Claude: ")
  if question == "" then return end

  local prompt = context .. question

  local tmpfile = vim.fn.tempname()
  local f = io.open(tmpfile, "w")
  f:write(prompt)
  f:close()

  vim.fn.system(string.format("tmux split-window -h -p 50 'claude \"$(cat %s)\" && rm %s'",
    vim.fn.shellescape(tmpfile), vim.fn.shellescape(tmpfile)))
end

vim.keymap.set('n', '<leader>cc', send_to_claude, { desc = 'Send to Claude in split' })
vim.keymap.set('v', '<leader>cc', send_to_claude, { desc = 'Send to Claude in split' })
