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

vim.api.nvim_create_user_command('FilePRs', function()
  local file = vim.fn.expand '%:.'

  -- Create a floating window
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.6)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = ' PRs affecting ' .. vim.fn.fnamemodify(file, ':t') .. ' ',
    title_pos = 'center',
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')

  -- Add loading message
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'Loading PRs...', '', 'This may take a moment...' })

  -- Close on 'q' or Escape
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':close<CR>', { noremap = true, silent = true })

  -- Open URL under cursor with 'o'
  vim.api.nvim_buf_set_keymap(buf, 'n', 'o', '', {
    noremap = true,
    silent = true,
    callback = function()
      local line = vim.api.nvim_get_current_line()
      -- Extract URL from the line
      local url = line:match 'https?://[%w-_%.%?%.:/%+=&]+'

      if url then
        -- Determine the open command based on OS
        local open_cmd
        if vim.fn.has 'mac' == 1 then
          open_cmd = 'open'
        elseif vim.fn.has 'unix' == 1 then
          open_cmd = 'xdg-open'
        elseif vim.fn.has 'win32' == 1 then
          open_cmd = 'start'
        else
          vim.notify('Unable to determine open command for your OS', vim.log.levels.ERROR)
          return
        end

        -- Open the URL
        vim.fn.jobstart({ open_cmd, url }, { detach = true })
        vim.notify('Opening: ' .. url, vim.log.levels.INFO)
      else
        vim.notify('No URL found on current line', vim.log.levels.WARN)
      end
    end,
  })

  -- Open PR in tmux review window with 'O'
  vim.api.nvim_buf_set_keymap(buf, 'n', 'O', '', {
    noremap = true,
    silent = true,
    callback = function()
      local line = vim.api.nvim_get_current_line()
      -- Extract PR number from the line (looking for "PR #123")
      local pr_number = line:match 'PR #(%d+)'

      if pr_number then
        local cmd = string.format("tmux new-window -c /Users/gkrohn/code/platform_work/review -n 'Review' \\; send-keys 'review %s -c' Enter", pr_number)

        -- Execute the tmux command
        vim.fn.system(cmd)
        vim.notify('Opening PR #' .. pr_number .. ' in tmux review window', vim.log.levels.INFO)
      else
        vim.notify('No PR number found on current line', vim.log.levels.WARN)
      end
    end,
  })

  -- Run the command asynchronously
  vim.fn.jobstart(string.format('git log --format="%%H" --follow -20 -- "%s"', file), {
    stdout_buffered = true,
    on_stdout = function(_, commits)
      if not commits or #commits == 0 then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'No commits found for this file' })
        return
      end

      -- Filter out empty strings
      local valid_commits = {}
      for _, commit in ipairs(commits) do
        if commit ~= '' then
          table.insert(valid_commits, commit)
        end
      end

      if #valid_commits == 0 then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'No commits found for this file' })
        return
      end

      -- Find PRs for commits
      local pr_count = 0
      local lines = { '# Pull Requests that modified this file', '' }

      for _, commit in ipairs(valid_commits) do
        if pr_count >= 5 then
          break
        end

        -- Try to find PR for this commit
        vim.fn.jobstart(string.format('gh pr list --search "%s" --state all --limit 1 --json number,title,url,author,mergedAt', commit), {
          stdout_buffered = true,
          on_stdout = function(_, pr_data)
            local pr_json = table.concat(pr_data, '')
            if pr_json and pr_json ~= '' and pr_json ~= '[]' then
              local ok, prs = pcall(vim.json.decode, pr_json)
              if ok and prs and #prs > 0 then
                local pr = prs[1]
                pr_count = pr_count + 1
                table.insert(lines, string.format('## PR #%d: %s', pr.number, pr.title))
                table.insert(lines, string.format('**Author:** %s', pr.author.login))
                if pr.mergedAt then
                  table.insert(lines, string.format('**Merged:** %s', pr.mergedAt:sub(1, 10)))
                end
                table.insert(lines, string.format('**URL:** %s', pr.url))
                table.insert(lines, '')

                -- Update buffer if it still exists
                if vim.api.nvim_buf_is_valid(buf) then
                  vim.schedule(function()
                    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
                  end)
                end
              end
            end
          end,
        })
      end

      -- Set a timeout to show "No PRs found" if nothing was found
      vim.defer_fn(function()
        if pr_count == 0 and vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
            '# No PRs found',
            '',
            'Commits were found for this file, but no associated PRs were found.',
            'This might happen if:',
            '- Changes were pushed directly to the branch',
            '- PRs were created before GitHub CLI tracking',
            '- The repository is not using GitHub PRs',
          })
        end
      end, 3000)
    end,
  })
end, {})

vim.api.nvim_create_user_command('RevertToDev', function()
  local file = vim.fn.expand '%:.'

  -- Confirm before reverting
  local confirm = vim.fn.confirm(string.format('Revert "%s" to origin/development branch?', file), '&Yes\n&No', 2)

  if confirm ~= 1 then
    vim.notify('Revert cancelled', vim.log.levels.INFO)
    return
  end

  -- Copy the origin/development version to the working directory (not staged)
  vim.fn.jobstart(string.format('git show origin/development:"%s"', file), {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        -- Write the development version to the file
        vim.schedule(function()
          local file_path = vim.fn.expand '%:p'
          local f = io.open(file_path, 'w')
          if f then
            for _, line in ipairs(data) do
              if line ~= '' then
                f:write(line .. '\n')
              end
            end
            f:close()

            -- Reload the buffer to show the changes
            vim.cmd 'edit!'
            vim.notify(string.format('Reverted "%s" to origin/development (unstaged)', file), vim.log.levels.INFO)
          else
            vim.notify('Failed to write file', vim.log.levels.ERROR)
          end
        end)
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.schedule(function()
          vim.notify(string.format('Failed to get origin/development version of "%s"', file), vim.log.levels.ERROR)
        end)
      end
    end,
  })
end, {})

vim.api.nvim_create_user_command('DiagnosticsToQf', function()
  vim.diagnostic.setqflist { severity = vim.diagnostic.severity.ERROR }
end, {})
