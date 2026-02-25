local wezterm = require 'wezterm'
local h = require 'utils/helpers'
local M = {}

M.get_wallpaper = function(dir)
  local cache_file = os.getenv 'HOME' .. '/.cache/wezterm_wallpaper'
  local wallpaper = nil

  local f = io.open(cache_file, 'r')
  if f then
    wallpaper = f:read '*line'
    f:close()
    local file_exists = io.open(wallpaper, 'r')
    if not file_exists then
      wallpaper = nil
    else
      file_exists:close()
    end
  end

  if not wallpaper then
    local wallpapers = {}
    for _, v in ipairs(wezterm.glob(dir)) do
      if not string.match(v, '%.DS_Store$') then
        table.insert(wallpapers, v)
      end
    end
    wallpaper = h.get_random_entry(wallpapers)
  end

  return {
    source = { File = { path = wallpaper } },
    height = 'Cover',
    width = 'Cover',
    horizontal_align = 'Center',
    repeat_x = 'Repeat',
    repeat_y = 'Repeat',
    opacity = 1,
    -- speed = 200,
  }
end

M.set_nvim_wallpaper = function(dir, name)
  return {
    source = { File = { path = os.getenv 'HOME' .. '/.config/wezterm/wallpapers/nvim/' .. name } },
    height = 'Cover',
    width = 'Cover',
    horizontal_align = 'Center',
    repeat_x = 'Repeat',
    repeat_y = 'Repeat',
    opacity = 1,
    -- speed = 200,
  }
end

M.set_tmux_session_wallpaper = function(value)
  local path = os.getenv 'HOME' .. '/.config/wezterm/wallpapers/sessions/' .. value .. '.jpeg'
  print(path)
  return {
    source = { File = { path = path } },
    height = 'Cover',
    width = 'Cover',
    horizontal_align = 'Center',
    repeat_x = 'Repeat',
    repeat_y = 'Repeat',
    opacity = 1,
    -- speed = 200,
  }
end

return M
