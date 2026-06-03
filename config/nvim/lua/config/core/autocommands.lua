-- remove the current line highlight
vim.api.nvim_create_autocmd('ColorScheme', {
  command = [[highlight CursorLine guibg=NONE cterm=NONE]],
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { 'aerospace.toml' },
  command = '!aerospace reload-config',
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*tmux.conf' },
  command = "execute 'silent !tmux source <afile> --silent'",
})

-- reload modules when lua files are saved
local group_id = vim.api.nvim_create_augroup('LuaReloadModule', { clear = true })

vim.api.nvim_create_autocmd('BufWritePost', {
  group = group_id,
  pattern = '*.lua',
  callback = function()
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    if first_line and first_line:match '^local%s+M%s*=%s*{}' then
      local file_path = vim.fn.expand '%:p'
      local module_name = vim.fn.fnamemodify(file_path, ':.:r')

      package.loaded[module_name] = nil
      vim.notify('Module Reloaded: ' .. module_name, nil, {
        title = 'Notification',
        timeout = 250,
        render = 'compact',
      })
    end
  end,
  desc = 'Reload the current module on save',
})

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  desc = 'Prevent colorscheme clearing self-defined DAP marker colors',
  callback = function()
    -- Reuse current SignColumn background (except for DapStoppedLine)
    local sign_column_hl = vim.api.nvim_get_hl(0, { name = 'SignColumn' })
    -- if bg or ctermbg aren't found, use bg = 'bg' (which means current Normal) and ctermbg = 'Black'
    -- convert to 6 digit hex value starting with #
    local sign_column_bg = (sign_column_hl.bg ~= nil) and ('#%06x'):format(sign_column_hl.bg) or 'Black'
    local sign_column_ctermbg = (sign_column_hl.ctermbg ~= nil) and sign_column_hl.ctermbg or 'Black'

    vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#00ff00', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
    vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2e4d3d', ctermbg = 'Green' })
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#c23127', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
    vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { fg = '#888ca6', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
    vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
  end,
})

-- reload current color scheme to pick up colors override if it was set up in a lazy plugin definition fashion
vim.cmd.colorscheme(vim.g.colors_name)

-- markdown soft wrap and formatting configuration
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    -- Command to copy markdown without line breaks for Confluence
    vim.api.nvim_buf_create_user_command(0, 'CopyForConfluence', function()
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local result = {}
      local in_code_block = false
      local current_para = {}

      for _, line in ipairs(lines) do
        -- Check for code block delimiter
        if line:match('^```') then
          -- Flush current paragraph before code block
          if #current_para > 0 then
            table.insert(result, table.concat(current_para, ' '))
            current_para = {}
          end
          in_code_block = not in_code_block
          table.insert(result, line)
        elseif in_code_block then
          -- Preserve code block lines as-is
          table.insert(result, line)
        elseif line:match('^%s*$') then
          -- Empty line - flush current paragraph
          if #current_para > 0 then
            table.insert(result, table.concat(current_para, ' '))
            current_para = {}
          end
          table.insert(result, '')
        else
          -- Regular text line - add to current paragraph
          table.insert(current_para, line)
        end
      end

      -- Flush any remaining paragraph
      if #current_para > 0 then
        table.insert(result, table.concat(current_para, ' '))
      end

      -- Copy to clipboard
      vim.fn.setreg('+', table.concat(result, '\n'))
      vim.notify('Copied to clipboard (code blocks preserved)', vim.log.levels.INFO)
    end, {})
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.textwidth = 80
    vim.opt_local.colorcolumn = ''
    -- Remove 't' and 'c' from formatoptions to disable auto-formatting while typing
    -- But keep formatoptions that work with gq for format-on-save
    vim.opt_local.formatoptions:remove({ 't', 'c' })
    vim.opt_local.formatoptions:append({ 'n' }) -- Recognize numbered lists

    -- Create :Zen command to toggle centered layout
    vim.api.nvim_buf_create_user_command(0, 'Zen', function()
      -- Check if we're already in zen mode by looking for side windows
      local current_win = vim.api.nvim_get_current_win()
      local wins = vim.api.nvim_list_wins()

      -- If we have more than 1 window, assume zen mode is active and close side windows
      if #wins > 1 then
        -- Close all windows except current
        vim.cmd('only')
        return
      end

      -- Enter zen mode
      local width = vim.api.nvim_win_get_width(0)
      local content_width = 100

      -- Only center if window is wide enough
      if width > content_width + 10 then
        local margin = math.floor((width - content_width) / 2)

        -- Create left padding window
        vim.cmd('topleft ' .. margin .. 'vsplit')
        local left_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(0, left_buf)
        vim.wo.winfixwidth = true
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.signcolumn = 'no'
        vim.wo.foldcolumn = '0'

        -- Go back to the markdown window
        vim.cmd('wincmd l')

        -- Create right padding window
        vim.cmd('botright vsplit')
        local right_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(0, right_buf)
        vim.wo.winfixwidth = true
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.signcolumn = 'no'
        vim.wo.foldcolumn = '0'

        -- Go back to the markdown window
        vim.cmd('wincmd h')
      end
    end, { desc = 'Toggle zen mode for markdown' })
  end,
})

-- lsp attach for diffview
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function(args)
    local buftype = vim.bo[args.buf].buftype
    if buftype == 'nowrite' then
      -- Get the filetype and manually trigger LSP
      local ft = vim.bo[args.buf].filetype
      if ft ~= '' and ft ~= 'diff' then
        vim.schedule(function()
          vim.cmd 'LspStart'
        end)
      end
    end
  end,
})

-- trying to make the quickfix list editable
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup('YOUR_GROUP_HERE', { clear = true }),
  desc = 'allow updating quickfix window',
  pattern = 'quickfix',
  callback = function(ctx)
    vim.bo.modifiable = true
    -- :vimgrep's quickfix window display format now includes start and end column (in vim and nvim) so adding 2nd format to match that
    vim.bo.errorformat = '%f|%l col %c| %m,%f|%l col %c-%k| %m'
    vim.keymap.set(
      'n',
      '<C-s>',
      '<Cmd>cgetbuffer|set nomodified|echo "quickfix/location list updated"<CR>',
      { buffer = true, desc = 'Update quickfix/location list with changes made in quickfix window' }
    )
  end,
})
