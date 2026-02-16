return {
  'dmtrKovalenko/fff.nvim',
  event = 'VeryLazy',
  build = function()
    -- This will download prebuilt binary or try to use existing rustup toolchain to build from source
    require('fff.download').download_or_build_binary()
  end,
  -- or if you are using nixos
  -- build = "nix run .#release",
  opts = { -- (optional)
    debug = {
      enabled = false, -- we expect your collaboration at least during the beta
      show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
    },
    layout = {
      prompt_position = 'top',
    },
    keymaps = {
      move_up = { '<Up>', '<C-k>' },
      move_down = { '<Down>', '<C-j>' },
    },
  },
  keys = {
    {
      '<leader>ff', -- try it if you didn't it is a banger keybinding for a picker
      function()
        require('fff').find_files()
      end,
      desc = 'FFFind files',
    },
  },
}
