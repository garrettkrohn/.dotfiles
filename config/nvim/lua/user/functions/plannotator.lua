local M = {}

local plannotator = vim.fn.expand '~/.cargo/bin/plannotator-tui'
local shim = vim.fn.expand '~/dotfiles/config/scripts/plannotator-herdr-shim'

-- State persisted per-session: which source file this buffer is reviewing
local source_file = nil
local review_buf = nil
local review_win = nil

local function is_jsonl(path)
  return path:sub(-6) == '.jsonl'
end

-- Read content for display: for .jsonl use plannotator --print, for .md read directly
local function get_display_content(path)
  if is_jsonl(path) then
    local result = vim.fn.system { plannotator, 'last', '--host', 'claude', '--session', path, '--print' }
    if vim.v.shell_error ~= 0 then
      return nil, 'plannotator-tui failed: ' .. result
    end
    return vim.split(result, '\n', { plain = true }), nil
  else
    local ok, lines = pcall(vim.fn.readfile, path)
    if not ok then
      return nil, 'could not read file: ' .. path
    end
    return lines, nil
  end
end

local function open_review_buf(path)
  source_file = path

  local lines, err = get_display_content(path)
  if err then
    vim.notify('[plannotator] ' .. err, vim.log.levels.ERROR)
    return
  end

  -- Create or reuse scratch buffer
  if review_buf and vim.api.nvim_buf_is_valid(review_buf) then
    vim.api.nvim_buf_set_option(review_buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(review_buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(review_buf, 'modifiable', false)
    if review_win and vim.api.nvim_win_is_valid(review_win) then
      vim.api.nvim_set_current_win(review_win)
    else
      vim.cmd 'vsplit'
      review_win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(review_win, review_buf)
    end
    return
  end

  review_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(review_buf, 'plannotator://' .. vim.fn.fnamemodify(path, ':t'))
  vim.api.nvim_buf_set_lines(review_buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(review_buf, 'filetype', 'markdown')
  vim.api.nvim_buf_set_option(review_buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(review_buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(review_buf, 'modifiable', false)

  vim.cmd 'vsplit'
  review_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(review_win, review_buf)

  local buf = review_buf
  local opts = { noremap = true, silent = true, buffer = buf }

  -- <leader>Pc — add comment on visual selection
  vim.keymap.set('v', '<leader>Pc', function()
    M.add_comment()
  end, vim.tbl_extend('force', opts, { desc = 'Plannotator: comment on selection' }))

  -- <leader>Ps — send annotations to Claude
  vim.keymap.set('n', '<leader>Ps', function()
    M.send()
  end, vim.tbl_extend('force', opts, { desc = 'Plannotator: send annotations' }))

  -- <leader>Pr — reload buffer
  vim.keymap.set('n', '<leader>Pr', function()
    M.reload()
  end, vim.tbl_extend('force', opts, { desc = 'Plannotator: reload' }))

  -- q to close
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(review_win, false)
    review_win = nil
    review_buf = nil
    source_file = nil
  end, vim.tbl_extend('force', opts, { desc = 'Plannotator: close' }))
end

-- Get visually selected text
local function get_visual_selection()
  local s_start = vim.fn.getpos "'<"
  local s_end = vim.fn.getpos "'>"
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  if #lines == 0 then
    return ''
  end
  lines[#lines] = string.sub(lines[#lines], 1, s_end[3])
  lines[1] = string.sub(lines[1], s_start[3])
  if n_lines == 1 then
    return lines[1]
  end
  return table.concat(lines, ' ')
end

function M.add_comment()
  if not source_file then
    vim.notify('[plannotator] no file open', vim.log.levels.WARN)
    return
  end

  -- Exit visual mode and grab selection
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', false)
  local quote = get_visual_selection()
  if quote == '' then
    vim.notify('[plannotator] no text selected', vim.log.levels.WARN)
    return
  end

  vim.ui.input({ prompt = 'Comment: ' }, function(text)
    if not text or text == '' then
      return
    end
    local result = vim.fn.system { plannotator, '--annotate', source_file, quote, text, 'comment' }
    if vim.v.shell_error ~= 0 then
      vim.notify('[plannotator] annotate failed: ' .. result, vim.log.levels.ERROR)
    else
      vim.notify('[plannotator] annotation added', vim.log.levels.INFO)
    end
  end)
end

-- Find the pane running claude in the current tmux session
local function find_claude_pane()
  -- Honour explicit override first
  local override = vim.env.PLANNOTATOR_TARGET_PANE
  if override and override ~= '' then
    return override
  end
  local session = vim.fn.system("tmux display-message -p '#{session_name}'"):gsub('\n', '')
  local panes = vim.fn.system(
    string.format(
      "tmux list-panes -s -t %s -F '#{pane_id} #{pane_current_command}'",
      vim.fn.shellescape(session)
    )
  )
  for pane_id, cmd in panes:gmatch('(%%[0-9]+)%s+([^\n]+)') do
    if cmd:match '^claude' then
      return pane_id
    end
  end
  return nil
end

function M.send()
  if not source_file then
    vim.notify('[plannotator] no file open', vim.log.levels.WARN)
    return
  end

  -- Export annotations to markdown
  local feedback = vim.fn.system { plannotator, '--export', source_file }
  if vim.v.shell_error ~= 0 or feedback:match '^No annotations' then
    vim.notify('[plannotator] nothing to send', vim.log.levels.WARN)
    return
  end

  local target_pane = find_claude_pane()
  if not target_pane then
    vim.notify('[plannotator] no claude pane found in session (set PLANNOTATOR_TARGET_PANE to override)', vim.log.levels.ERROR)
    return
  end

  local result = vim.fn.system { shim, 'agent', 'prompt', target_pane, feedback }
  if vim.v.shell_error ~= 0 then
    vim.notify('[plannotator] send failed: ' .. result, vim.log.levels.ERROR)
  else
    vim.notify('[plannotator] sent to Claude (' .. target_pane .. ')', vim.log.levels.INFO)
  end
end

function M.reload()
  if not source_file or not review_buf or not vim.api.nvim_buf_is_valid(review_buf) then
    vim.notify('[plannotator] nothing to reload', vim.log.levels.WARN)
    return
  end

  local lines, err = get_display_content(source_file)
  if err then
    vim.notify('[plannotator] ' .. err, vim.log.levels.ERROR)
    return
  end

  vim.api.nvim_buf_set_option(review_buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(review_buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(review_buf, 'modifiable', false)
  vim.notify('[plannotator] reloaded', vim.log.levels.INFO)
end

-- Open a plannotator review for a file path, or the latest Claude session if omitted
function M.open(path)
  if path and path ~= '' then
    open_review_buf(path)
    return
  end

  -- Auto-detect latest session for current project
  -- Claude slugifies cwd by replacing '/', '_', and '.' with '-'
  local cwd = vim.fn.getcwd()
  local slug = cwd:gsub('[/_%.]', '-')
  local project_dir = vim.fn.expand('~/.claude/projects') .. slug
  local result = vim.fn.system('ls -t ' .. project_dir .. '/*.jsonl 2>/dev/null | head -1')
  result = result:gsub('\n', '')
  if result == '' then
    vim.notify('[plannotator] no Claude transcript found in ' .. project_dir, vim.log.levels.ERROR)
    return
  end
  open_review_buf(result)
end

-- User commands
vim.api.nvim_create_user_command('Plannotator', function(opts)
  M.open(opts.args)
end, { nargs = '?', complete = 'file', desc = 'Open plannotator review' })

vim.api.nvim_create_user_command('PlannotatorSend', function()
  M.send()
end, { desc = 'Send plannotator annotations to Claude' })

vim.api.nvim_create_user_command('PlannotatorReload', function()
  M.reload()
end, { desc = 'Reload plannotator review buffer' })

-- Global keymaps (outside the buffer-local ones) to open plannotator
vim.keymap.set('n', '<leader>Po', function()
  M.open()
end, { desc = 'Plannotator: open latest session' })

vim.keymap.set('n', '<leader>PO', function()
  local file = vim.fn.input('File: ', '', 'file')
  if file ~= '' then
    M.open(file)
  end
end, { desc = 'Plannotator: open file' })

return M
