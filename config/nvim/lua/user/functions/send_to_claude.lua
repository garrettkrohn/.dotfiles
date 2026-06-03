local function send_to_claude()
  -- Get visual selection using register
  local save_reg = vim.fn.getreg('"')
  local save_regtype = vim.fn.getregtype('"')

  -- Yank the visual selection
  vim.cmd('normal! "xy')
  local selection = vim.fn.getreg('x')

  -- Restore original register
  vim.fn.setreg('"', save_reg, save_regtype)

  -- Get file info
  local relative_path = vim.fn.expand("%:.")

  -- Build context
  local context = string.format("File: %s\n```\n%s\n```\n\n",
    relative_path, selection)

  -- Prompt user for question
  local question = vim.fn.input("Ask Claude: ")
  if question == "" then return end

  -- Create prompt
  local prompt = context .. question

  -- Write prompt to temp file to handle newlines and special chars properly
  local tmpfile = vim.fn.tempname()
  local f = io.open(tmpfile, "w")
  f:write(prompt)
  f:close()

  -- Open tmux split on the right with Claude Code, reading from temp file
  vim.fn.system(string.format("tmux split-window -h -p 50 'claude \"$(cat %s)\" && rm %s'",
    vim.fn.shellescape(tmpfile), vim.fn.shellescape(tmpfile)))
end

vim.keymap.set('v', '<leader>cc', send_to_claude, { desc = 'Send to Claude in split' })
