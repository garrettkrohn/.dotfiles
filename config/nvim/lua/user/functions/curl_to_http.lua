local M = {}

-- Function to convert curl command to HTTP format
function M.curl_to_http()
  -- Get the filetype to ensure we're in an http file
  local filetype = vim.bo.filetype
  if filetype ~= 'http' then
    vim.notify('This command only works in *.http files', vim.log.levels.WARN)
    return
  end

  -- Get the visual selection
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line = start_pos[2]
  local end_line = end_pos[2]

  -- Get the selected lines
  local lines = vim.fn.getline(start_line, end_line)

  -- Join lines into a single string
  local curl_command = table.concat(lines, '\n')

  -- Remove markdown headers (###)
  curl_command = curl_command:gsub('^%s*#+%s*\n*', '')

  -- Remove line continuations (backslash followed by newline)
  curl_command = curl_command:gsub('\\%s*\n%s*', ' ')

  -- Clean up extra spaces
  curl_command = curl_command:gsub('%s+', ' ')

  -- Remove HTTP method prefix if present (GET, POST, etc.) before 'curl'
  curl_command = curl_command:gsub('^%s*%u+%s+curl', 'curl')

  -- Remove HTTP version suffix - be more aggressive
  curl_command = curl_command:gsub('HTTP/%d+%.%d+', '')

  -- Trim whitespace
  curl_command = curl_command:gsub('^%s*(.-)%s*$', '%1')

  -- Extract URL (handle both quoted and unquoted)
  -- First try URL immediately after curl
  local url = curl_command:match("curl%s+'([^']+)'")
    or curl_command:match('curl%s+"([^"]+)"')
    or curl_command:match('curl%s+([^%s%-]+)')

  -- If not found, look for http(s):// anywhere in the command (but not in -d data)
  if not url then
    -- Split at -d to avoid matching URLs in the body
    local before_data = curl_command:match('(.-)%-%-?d%s+') or curl_command
    url = before_data:match('(https?://[^%s\'\"]+)')
  end

  if not url then
    vim.notify('Could not extract URL from curl command', vim.log.levels.ERROR)
    return
  end

  -- Extract method (default to GET)
  local method = curl_command:match("%-X%s+'([^']+)'")
    or curl_command:match('%-X%s+"([^"]+)"')
    or curl_command:match('%-X%s+(%w+)')
    or curl_command:match("%-%-request%s+'([^']+)'")
    or curl_command:match('%-%-request%s+"([^"]+)"')
    or curl_command:match('%-%-request%s+(%w+)')
    or 'GET'

  -- Extract headers - process the entire string to find all -H flags
  local headers = {}

  -- Split by -H and process each part
  local pos = 1
  while true do
    local h_pos = curl_command:find('%-H%s+', pos)
    if not h_pos then break end

    -- Find the quote after -H
    local quote_start = curl_command:find('["\']', h_pos)
    if not quote_start then break end

    local quote_char = curl_command:sub(quote_start, quote_start)
    local quote_end = curl_command:find(quote_char, quote_start + 1)

    if quote_end then
      local header = curl_command:sub(quote_start + 1, quote_end - 1)
      table.insert(headers, header)
      pos = quote_end + 1
    else
      break
    end
  end

  -- Extract data/body
  local body = curl_command:match("%-d%s+'([^']+)'")
    or curl_command:match('%-d%s+"([^"]+)"')
    or curl_command:match("%-%-data%s+'([^']+)'")
    or curl_command:match('%-%-data%s+"([^"]+)"')
    or curl_command:match("%-%-data%-raw%s+'([^']+)'")
    or curl_command:match('%-%-data%-raw%s+"([^"]+)"')

  -- Build HTTP format
  local http_lines = {}

  -- Add a comment/title line
  table.insert(http_lines, '### Converted from curl')
  table.insert(http_lines, '')

  -- Add request line
  table.insert(http_lines, string.format('%s %s HTTP/1.1', method, url))

  -- Add headers
  for _, header in ipairs(headers) do
    -- Parse header into name and value
    local name, value = header:match('^([^:]+):%s*(.*)')
    if name and value then
      -- Capitalize header names properly (handle hyphenated names)
      name = name:gsub('(%a)([%w%-]*)', function(first, rest)
        return first:upper() .. rest:lower()
      end):gsub('%-(%a)', function(letter)
        return '-' .. letter:upper()
      end)

      -- Skip cookie headers if you want, or include them
      -- Uncomment the next line to skip cookie headers:
      -- if name:lower() ~= 'cookie' then
      table.insert(http_lines, string.format('%s: %s', name, value))
      -- end
    end
  end

  -- Add body if present
  if body then
    table.insert(http_lines, '')
    table.insert(http_lines, body)
  end

  table.insert(http_lines, '')

  -- Delete the selected lines
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, {})

  -- Insert the converted text at the start position
  vim.api.nvim_buf_set_lines(0, start_line - 1, start_line - 1, false, http_lines)

  -- Move cursor to the inserted text
  vim.api.nvim_win_set_cursor(0, {start_line, 0})
end

-- Create command
vim.api.nvim_create_user_command('CurlToHttp', M.curl_to_http, { range = true })

-- Create keymap only for http files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'http',
  callback = function()
    vim.keymap.set('v', '<leader>ch', M.curl_to_http, {
      buffer = true,
      desc = 'Convert curl to HTTP format',
      silent = true
    })
  end,
})

return M
