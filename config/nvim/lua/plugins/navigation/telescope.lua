return {
  {
    'nvim-telescope/telescope.nvim',
    -- enabled = false,
    tag = '0.1.8',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      {
        'nvim-telescope/telescope-frecency.nvim',
        version = '*',
      },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              ['<C-k>'] = require('telescope.actions').move_selection_previous,
              ['<C-j>'] = require('telescope.actions').move_selection_next,
              ['<C-q>'] = require('telescope.actions').send_selected_to_qflist + require('telescope.actions').open_qflist,
            },
          },
          file_ignore_patterns = { '.git/', 'node_modules' },
          layout_config = {
            height = 0.90,
            width = 0.90,
            preview_cutoff = 0,
            horizontal = { preview_width = 0.60 },
            vertical = { width = 0.55, height = 0.9, preview_cutoff = 0 },
            prompt_position = 'top',
          },
          path_display = { 'smart' },
          prompt_position = 'top',
          prompt_prefix = ' ',
          selection_caret = ' ',
          sorting_strategy = 'ascending',
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--hidden',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--trim',
          },
        },
        pickers = {
          buffers = {
            prompt_prefix = '󰸩 ',
          },
          commands = {
            prompt_prefix = ' ',
            layout_config = {
              height = 0.63,
              width = 0.78,
            },
          },
          command_history = {
            prompt_prefix = ' ',
            layout_config = {
              height = 0.63,
              width = 0.58,
            },
          },
          git_files = {
            prompt_prefix = '󰊢 ',
            show_untracked = true,
          },
          find_files = {
            prompt_prefix = ' ',
            find_command = { 'fd', '-H' },
          },
          live_grep = {
            prompt_prefix = '󰱽 ',
          },
          grep_string = {
            prompt_prefix = '󰱽 ',
          },
        },
        extensions = {
          fzf = {},
          smart_open = {
            cwd_only = true,
            filename_first = true,
          },
        },
      }

      require('telescope').load_extension 'fzf'
      require('telescope').load_extension 'frecency'

      vim.cmd [[
                highlight TelescopeBorder guifg=#40a02b
                highlight TelescopePromptBorder guifg=#179299
                highlight TelescopePreviewBorder guifg=#ea76cb
            ]]

      vim.keymap.set('n', '<space>fh', require('telescope.builtin').help_tags)
      vim.keymap.set('n', '<space>fd', require('telescope.builtin').find_files)
      vim.keymap.set('n', '<space>en', function()
        require('telescope.builtin').find_files {
          cwd = vim.fn.stdpath 'config',
        }
      end)
      vim.keymap.set('n', '<space>ep', function()
        require('telescope.builtin').find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy'),
        }
      end)
    end,
  },
}

-- return {
--   'nvim-telescope/telescope.nvim',
--   -- enabled = false,
--   dependencies = {
--     {
--       'prochri/telescope-all-recent.nvim',
--       dependencies = {
--         'kkharji/sqlite.lua',
--       },
--       opts = {},
--     },
--     {
--       'danielfalk/smart-open.nvim',
--       branch = '0.2.x',
--       dependencies = {
--         'kkharji/sqlite.lua',
--         { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
--       },
--     },
--
--     'AckslD/nvim-neoclip.lua',
--     'danielvolchek/tailiscope.nvim',
--     'debugloop/telescope-undo.nvim',
--     'natecraddock/telescope-zf-native.nvim',
--     'piersolenski/telescope-import.nvim',
--     {
--       'nvim-telescope/telescope-live-grep-args.nvim',
--       version = '^1.0.0',
--     },
--     'vuki656/package-info.nvim',
--   },
--   -- apply the config and additionally load fzf-native
--   config = function(_, opts)
--     local telescope = require 'telescope'
--     telescope.setup(opts)
--     telescope.load_extension 'telescope-fzf-native'
--     telescope.load_extension 'import'
--     telescope.load_extension 'live_grep_args'
--     telescope.load_extension 'neoclip'
--     -- telescope.load_extension 'notify'
--     telescope.load_extension 'package_info'
--     telescope.load_extension 'smart_open'
--     telescope.load_extension 'tailiscope'
--     telescope.load_extension 'undo'
--     -- telescope.load_extension 'zf-native'
--   end,
--
--   opts = {
--     defaults = {
--       mappings = {
--         i = {
--           ['<C-u>'] = false,
--           ['<C-d>'] = false,
--           ['<C-k>'] = require('telescope.actions').move_selection_previous, -- move to prev result
--           ['<C-j>'] = require('telescope.actions').move_selection_next, -- move to next result
--           ['<C-q>'] = require('telescope.actions').send_selected_to_qflist + require('telescope.actions').open_qflist, -- send selected to quickfixlist
--         },
--       },
--       file_ignore_patterns = { '.git/', 'node_modules' },
--       layout_config = {
--         height = 0.90,
--         width = 0.90,
--         preview_cutoff = 0,
--         horizontal = { preview_width = 0.60 },
--         vertical = { width = 0.55, height = 0.9, preview_cutoff = 0 },
--         prompt_position = 'top',
--       },
--       path_display = { 'smart' },
--       prompt_position = 'top',
--       prompt_prefix = ' ',
--       selection_caret = ' ',
--       sorting_strategy = 'ascending',
--       vimgrep_arguments = {
--         'rg',
--         '--color=never',
--         '--no-heading',
--         '--hidden',
--         '--with-filename',
--         '--line-number',
--         '--column',
--         '--smart-case',
--         '--trim', -- add this value
--       },
--     },
--     pickers = {
--       buffers = {
--         prompt_prefix = '󰸩 ',
--       },
--       commands = {
--         prompt_prefix = ' ',
--         layout_config = {
--           height = 0.63,
--           width = 0.78,
--         },
--       },
--       command_history = {
--         prompt_prefix = ' ',
--         layout_config = {
--           height = 0.63,
--           width = 0.58,
--         },
--       },
--       git_files = {
--         prompt_prefix = '󰊢 ',
--         show_untracked = true,
--       },
--       find_files = {
--         prompt_prefix = ' ',
--         find_command = { 'fd', '-H' },
--       },
--       live_grep = {
--         prompt_prefix = '󰱽 ',
--       },
--       grep_string = {
--         prompt_prefix = '󰱽 ',
--       },
--     },
--     extensions = {
--       ['zf-native'] = {
--         file = { -- options for sorting file-like items
--           enable = true, -- override default telescope file sorter
--           highlight_results = true, -- highlight matching text in results
--           match_filename = true, -- enable zf filename match priority
--         },
--         generic = { -- options for sorting all other items
--           enable = true, -- override default telescope generic item sorter
--           highlight_results = true, -- highlight matching text in results
--           match_filename = false, -- disable zf filename match priority
--         },
--       },
--       smart_open = {
--         cwd_only = true,
--         filename_first = true,
--       },
--     },
--   },
--   keys = function()
--     return {
--       -- TODO: last telescope
--       { '<leader>*', '<cmd>Telescope grep_string<cr>', { silent = true, desc = 'Grep Word Under Cursor' } },
--       { '<leader>.', '<cmd>Telescope resume<cr>', { silent = true, desc = 'Resume Telescope' } },
--     }
--   end,
-- }
