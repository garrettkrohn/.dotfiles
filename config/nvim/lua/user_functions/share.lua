local M = {}

local share = false

function M.toggleShare()
  local stdout = vim.loop.new_tty(1, false)
  if stdout ~= nil then
    -- Invert the share variable
    share = not share
    -- Convert the boolean to a string that can be passed to the stdout:write function
    local shareStr = share and 'true' or 'false'
    -- Encode the shareStr to base64
    local encodedShareStr = vim.fn.system({ 'base64' }, shareStr)
    -- Write the encodedShareStr to stdout
    stdout:write(('\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\'):format('SHARE', encodedShareStr))
    vim.cmd [[redraw]]
  end
end

vim.cmd 'command! Krchmode lua require("user_functions.share").toggleShare()'

return M
