local M = {}

function M.peek_type()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/typeDefinition', params, function(err, result, ctx, config)
    if err or not result or vim.tbl_isempty(result) then
      vim.notify('No type definition found', vim.log.levels.INFO)
      return
    end

    -- Get the location
    local location = result[1]
    local uri = location.uri or location.targetUri
    local range = location.range or location.targetRange

    -- Check if it's a file URI we can read directly
    if not uri:match('^file://') then
      -- For non-file URIs (jdt://, jar:, etc.), use preview_location
      vim.lsp.util.preview_location(location, { border = 'rounded', max_height = 30 })
      return
    end

    local filepath = vim.uri_to_fname(uri)
    local start_line = range.start.line

    -- Check if file exists and is readable
    if vim.fn.filereadable(filepath) == 0 then
      vim.lsp.util.preview_location(location, { border = 'rounded', max_height = 30 })
      return
    end

    -- Read more lines for context (50 lines from the definition)
    local lines = vim.fn.readfile(filepath, '', start_line + 50)
    local content = {}
    for i = start_line + 1, math.min(start_line + 50, #lines) do
      table.insert(content, lines[i])
    end

    -- Create floating window
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

    -- Set filetype for syntax highlighting
    local filetype = vim.filetype.match({ filename = filepath })
    if filetype then
      vim.api.nvim_buf_set_option(buf, 'filetype', filetype)
    end

    -- Open floating window
    local width = math.min(100, vim.o.columns - 4)
    local height = math.min(30, #content)
    local win = vim.api.nvim_open_win(buf, false, {
      relative = 'cursor',
      row = 1,
      col = 0,
      width = width,
      height = height,
      style = 'minimal',
      border = 'rounded',
    })

    -- Set window options
    vim.api.nvim_win_set_option(win, 'wrap', false)
    vim.api.nvim_win_set_option(win, 'cursorline', true)

    -- Close window on any key press or cursor movement (with slight delay to avoid immediate close)
    vim.defer_fn(function()
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'BufLeave', 'InsertEnter' }, {
        buffer = vim.api.nvim_get_current_buf(),
        callback = function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
            return true -- Delete autocmd after firing
          end
        end,
      })
    end, 100)
  end)
end

return M
