return {
  'nvim-tree/nvim-tree.lua',
  enabled = false,
  opts = {
    view = {
      relativenumber = true,
      float = {
        enable = true,
        open_win_config = function()
          local screen_w = vim.opt.columns:get()
          local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
          local window_w = (screen_w * 1) / 1.75
          local window_h = screen_h * 0.8
          local window_w_int = math.floor(window_w)
          local window_h_int = math.floor(window_h)
          local center_x = (screen_w - window_w) / 2
          local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
          return {
            border = 'rounded',
            relative = 'editor',
            row = center_y,
            col = center_x,
            width = window_w_int,
            height = window_h_int,
          }
        end,
      },
    },
    -- change folder arrow icons
    renderer = {
      icons = {
        glyphs = {
          folder = {
            arrow_closed = '', -- arrow when folder is closed
            arrow_open = '', -- arrow when folder is open
          },
        },
      },
    },
    -- disable window_picker for
    -- explorer to work well with
    -- window splits
    actions = {
      open_file = {
        window_picker = {
          enable = false,
        },
      },
    },
    -- 	git = {
    -- 		ignore = false,
    -- 	},
  },
}
