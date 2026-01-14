return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    dashboard = {
      preset = {
        header = [[
          ██████╗ ██████╗        ██╗   ██╗██╗███╗   ███╗
          ██╔══██╗██╔══██╗       ██║   ██║██║████╗ ████║
          ██║  ██║██████╔╝       ██║   ██║██║██╔████╔██║
          ██║  ██║██╔══██╗       ╚██╗ ██╔╝██║██║╚██╔╝██║
          ██████╔╝██║  ██║██╗     ╚████╔╝ ██║██║ ╚═╝ ██║
          ╚═════╝ ╚═╝  ╚═╝╚═╝      ╚═══╝  ╚═╝╚═╝     ╚═╝
          ]],
        keys = {
          {
            icon = ' ',
            key = 'f',
            desc = 'Find File',
            action = function()
              require('fff').find_files()
            end,
          },
          {
            icon = '󰊄 ',
            key = 'r',
            desc = 'Recent Files',
            action = function()
              Snacks.picker.recent()
            end,
          },
          {
            icon = ' ',
            key = 'c',
            desc = 'Config',
            action = function()
              Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
            end,
          },
          { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
    },
    indent = {
      enabled = true,
    },
    -- rest of your config...
    ---@class snacks.lazygit.Config: snacks.terminal.Opts
    ---@field args? string[]
    ---@field theme? snacks.lazygit.Theme
    lazygit = {
      enabled = true,
      configure = true,
      config = {
        os = { editPreset = 'nvim-remote' },
        gui = {
          -- set to an empty string "" to disable icons
          nerdFontsVersion = '3',
        },
      },
    },
    picker = {
      enabled = false,
    },
    notifier = {
      enabled = true,
      timeout = 2000,
    },
    scratch = {
      enabled = true,
    },
  },
  keys = {
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
    {
      '<leader>rr',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    -- {
    --   ']]',
    --   function()
    --     Snacks.words.jump(vim.v.count1)
    --   end,
    --   desc = 'Next Reference',
    --   mode = { 'n', 't' },
    -- },
    -- {
    --   '[[',
    --   function()
    --     Snacks.words.jump(-vim.v.count1)
    --   end,
    --   desc = 'Prev Reference',
    --   mode = { 'n', 't' },
    -- },
    {
      '<leader>,',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>/',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Grep',
    },
    {
      '<leader>:',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Command History',
    },
    -- {
    --   '<leader>ff',
    --   function()
    --     Snacks.picker.files()
    --   end,
    --   desc = 'Find Files',
    -- },
    {
      '<leader>fr',
      function()
        Snacks.picker.lsp_references()
      end,
      desc = 'Find References',
    },
    {
      '<leader>fi',
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = 'Find Implementations',
    },
    -- find
    {
      '<leader>fb',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>fc',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = 'Find Config File',
    },
    -- {
    --   '<leader>ff',
    --   function()
    --     Snacks.picker.files()
    --   end,
    --   desc = 'Find Files',
    -- },
    -- {
    --   '<leader>fg',
    --   function()
    --     Snacks.picker.git_files()
    --   end,
    --   desc = 'Find Git Files',
    -- },
    {
      '<leader>.',
      function()
        Snacks.picker.recent()
      end,
      desc = 'Recent',
    },
    -- git
    {
      '<leader>fg',
      function()
        Snacks.picker.git_log()
      end,
      desc = 'Git Log',
    },
    -- {
    --   '<leader>gs',
    --   function()
    --     Snacks.picker.git_status()
    --   end,
    --   desc = 'Git Status',
    -- },
    {
      '<leader>sb',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Buffer Lines',
    },
    {
      '<leader>sB',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = 'Grep Open Buffers',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'Visual selection or word',
      mode = { 'n', 'x' },
    },
    -- search
    {
      '<leader>s"',
      function()
        Snacks.picker.registers()
      end,
      desc = 'Registers',
    },
    {
      '<leader>sa',
      function()
        Snacks.picker.autocmds()
      end,
      desc = 'Autocmds',
    },
    {
      '<leader>sc',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Command History',
    },
    {
      '<leader>sC',
      function()
        Snacks.picker.commands()
      end,
      desc = 'Commands',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = 'Diagnostics',
    },
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = 'Help Pages',
    },
    {
      '<leader>sH',
      function()
        Snacks.picker.highlights()
      end,
      desc = 'Highlights',
    },
    {
      '<leader>sj',
      function()
        Snacks.picker.jumps()
      end,
      desc = 'Jumps',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = 'Keymaps',
    },
    {
      '<leader>sl',
      function()
        Snacks.picker.loclist()
      end,
      desc = 'Location List',
    },
    {
      '<leader>sM',
      function()
        Snacks.picker.man()
      end,
      desc = 'Man Pages',
    },
    {
      '<leader>sm',
      function()
        Snacks.picker.marks()
      end,
      desc = 'Marks',
    },
    {
      '<leader>sR',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Resume',
    },
    {
      '<leader>sq',
      function()
        Snacks.picker.qflist()
      end,
      desc = 'Quickfix List',
    },
    {
      '<leader>uC',
      function()
        Snacks.picker.colorschemes()
      end,
      desc = 'Colorschemes',
    },
    {
      '<leader>qp',
      function()
        Snacks.picker.projects()
      end,
      desc = 'Projects',
    },
    -- LSP
    {
      'gd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'Goto Definition',
    },
    {
      'gr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'References',
    },
    {
      'gi',
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = 'Goto Implementation',
    },
    {
      'gy',
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = 'Goto T[y]pe Definition',
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = 'LSP Symbols',
    },
  },
}
