return {
  'stevearc/oil.nvim',
  lazy = false,
  keys = {
    { '<leader><leader>', ':Oil<CR>', desc = 'Toggle oil' },
  },
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  config = function()
    require('oil').setup({ show_hidden = true })

    local api = vim.api
    local preview_buf, preview_win

    local function close_preview()
      if preview_win and api.nvim_win_is_valid(preview_win) then
        api.nvim_win_close(preview_win, true)
      end
      if preview_buf and api.nvim_buf_is_valid(preview_buf) then
        api.nvim_buf_delete(preview_buf, { force = true })
      end
      preview_win, preview_buf = nil, nil
    end

    local function open_preview()
      if preview_win and api.nvim_win_is_valid(preview_win) then return end
      preview_buf = api.nvim_create_buf(false, true)
      local width = math.floor(vim.o.columns * 0.8)
      local height = vim.o.lines - vim.o.cmdheight - 2
      preview_win = api.nvim_open_win(preview_buf, false, {
        relative = 'editor',
        col = vim.o.columns - width,
        row = 0,
        width = width,
        height = height,
        border = 'rounded',
        style = 'minimal',
      })
    end

    local function update_preview()
      if not preview_win or not api.nvim_win_is_valid(preview_win) then return end
      local entry = require('oil').get_cursor_entry()
      if not entry or entry.type ~= 'file' then
        api.nvim_buf_set_lines(preview_buf, 0, -1, false, {})
        return
      end
      local dir = require('oil').get_current_dir()
      if not dir then return end
      local filepath = dir .. entry.name
      if vim.fn.filereadable(filepath) == 1 then
        api.nvim_buf_set_lines(preview_buf, 0, -1, false, vim.fn.readfile(filepath))
        local ft = vim.filetype.match({ filename = filepath })
        if ft then vim.bo[preview_buf].filetype = ft end
      else
        api.nvim_buf_set_lines(preview_buf, 0, -1, false, {})
      end
    end

    api.nvim_create_autocmd('FileType', {
      pattern = 'oil',
      callback = function()
        open_preview()
        api.nvim_create_autocmd('CursorMoved', { buffer = 0, callback = update_preview })
        api.nvim_create_autocmd('BufLeave', { buffer = 0, once = true, callback = close_preview })
      end,
    })
  end,
}
