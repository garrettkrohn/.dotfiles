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

-- set text width to 80 for md files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt.textwidth = 80
  end,
})
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    if vim.bo.filetype ~= 'markdown' then
      vim.opt.textwidth = 0
    end
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
