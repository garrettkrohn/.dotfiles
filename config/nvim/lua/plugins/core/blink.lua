return {
  'saghen/blink.cmp',
  version = '1.*',
  event = 'VeryLazy',
  dependencies = {
    'brenoprata10/nvim-highlight-colors',
    'folke/lazydev.nvim',
    'MahanRahmati/blink-nerdfont.nvim',
    'moyiz/blink-emoji.nvim',
    'rafamadriz/friendly-snippets',
    {
      'Kaiser-Yang/blink-cmp-git',
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {
      'onsails/lspkind.nvim',
      opts = {},
    },
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = { nerd_font_variant = 'mono' },
    signature = { enabled = true },

    keymap = { preset = 'default', ['<C-j>'] = { 'select_next', 'fallback' }, ['<C-k>'] = { 'select_prev', 'fallback' } },

    completion = {
      documentation = { auto_show = true },
      list = { selection = { preselect = true, auto_insert = true } },
      menu = {
        -- auto_show_delay_ms = 500,
        draw = {
          components = {
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                if ctx.item.source_name == 'LSP' then
                  local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                  if color_item and color_item.abbr then
                    icon = color_item.abbr
                  else
                    icon = require('lspkind').symbolic(ctx.kind, {
                      mode = 'symbol',
                    })
                  end
                elseif vim.tbl_contains({ 'Path' }, ctx.source_name) then
                  local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                end

                return icon .. ctx.icon_gap
              end,
              highlight = function(ctx)
                local highlight = 'BlinkCmpKind' .. ctx.kind
                if ctx.item.source_name == 'LSP' then
                  local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                  if color_item and color_item.abbr_hl_group then
                    highlight = color_item.abbr_hl_group
                  end
                end
                return highlight
              end,
            },
          },
        },
      },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'emoji', 'nerdfont' },
      providers = {
        git = {
          module = 'blink-cmp-git',
          name = 'Git',
          enabled = function()
            return vim.tbl_contains({ 'octo', 'gitcommit', 'markdown' }, vim.bo.filetype)
          end,
          --- @module 'blink-cmp-git'
          --- @type blink-cmp-git.Options
          opts = {
            -- TODO: get neogit working
            -- options for the blink-cmp-git
          },
        },
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
        nerdfont = {
          -- TODO: update appearance to only show emoji and not lsp symbol
          module = 'blink-nerdfont',
          name = 'Nerd Fonts',
          score_offset = 15,
          opts = { insert = true },
        },
        opencode = {
          module = 'opencode.cmp.blink',
        },
        emoji = {
          -- TODO: update appearance to only show emoji and not lsp symbol
          module = 'blink-emoji',
          name = 'Emoji',
          score_offset = 25,
          opts = { insert = true },
        },
      },
      per_filetype = {
        opencode_ask = { 'opencode', 'buffer' },
        lua = { inherit_defaults = true, 'lazydev' },
      },
    },
    fuzzy = { implementation = 'lua' },
  },
  opts_extend = { 'sources.default' },
}

-- return {
--   enabled = false,
--   'saghen/blink.cmp',
--   -- dependencies = { 'rafamadriz/friendly-snippets' },
--
--   version = '1.*',
--
--   ---@module 'blink.cmp'
--   ---@type blink.cmp.Config
--   opts = {
--     -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
--     -- 'super-tab' for mappings similar to vscode (tab to accept)
--     -- 'enter' for enter to accept
--     -- 'none' for no mappings
--     --
--     -- All presets have the following mappings:
--     -- C-space: Open menu or open docs if already open
--     -- C-n/C-p or Up/Down: Select next/previous item
--     -- C-e: Hide menu
--     -- C-k: Toggle signature help (if signature.enabled = true)
--     --
--     -- See :h blink-cmp-config-keymap for defining your own keymap
--     keymap = { preset = 'default', ['<C-j>'] = { 'select_next', 'fallback' }, ['<C-k>'] = { 'select_prev', 'fallback' } },
--
--     appearance = {
--       -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
--       -- Adjusts spacing to ensure icons are aligned
--       nerd_font_variant = 'mono',
--     },
--
--     -- (Default) Only show the documentation popup when manually triggered
--     completion = {
--       menu = { enabled = false },
--       ghost_text = { enabled = false }, -- ← CRITICAL
--       documentation = { auto_show = false },
--     },
--     signature = { enabled = false },
--
--     -- Default list of enabled providers defined so that you can extend it
--     -- elsewhere in your config, without redefining it, due to `opts_extend`
--     sources = {
--       default = { 'lsp', 'path', 'snippets', 'buffer' },
--     },
--
--     -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
--     -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
--     -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
--     --
--     -- See the fuzzy documentation for more information
--     -- fuzzy = { implementation = 'prefer_rust_with_warning' },
--     fuzzy = {
--       implementation = 'lua', -- Force Lua implementation instead of Rust
--     },
--   },
--   opts_extend = { 'sources.default' },
-- }
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- --
-- -- local trigger_text = ';'
-- --
-- -- return {
-- --   'saghen/blink.cmp',
-- --
-- --   version = '0.9.3',
-- --   opts = function(_, opts)
-- --     -- 'default' for mappings similar to built-in completion
-- --     -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
-- --     -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
-- --     -- See the full "keymap" documentation for information on defining your own keymap.
-- --     opts.keymap = {
-- --       preset = 'default',
-- --       ['<C-k>'] = { 'select_prev', 'fallback' },
-- --       ['<C-j>'] = { 'select_next', 'fallback' },
-- --       ['<Enter>'] = { 'accept', 'fallback' },
-- --     }
-- --
-- --     opts.appearance = {
-- --       -- Sets the fallback highlight groups to nvim-cmp's highlight groups
-- --       -- Useful for when your theme doesn't support blink.cmp
-- --       -- Will be removed in a future release
-- --       use_nvim_cmp_as_default = true,
-- --       -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
-- --       -- Adjusts spacing to ensure icons are aligned
-- --       nerd_font_variant = 'mono',
-- --     }
-- --
-- --     -- Default list of enabled providers defined so that you can extend it
-- --     -- elsewhere in your config, without redefining it, due to `opts_extend`
-- --     opts.sources = {
-- --       default = { 'lsp', 'path', 'snippets', 'buffer' },
-- --       providers = {
-- --         luasnip = {
-- --           name = 'luasnip',
-- --           enabled = true,
-- --           module = 'blink.cmp.sources.luasnip',
-- --           min_keyword_length = 2,
-- --           fallbacks = { 'snippets' },
-- --           score_offset = 85,
-- --           max_items = 8,
-- --           -- Only show luasnip items if I type the trigger_text characters, so
-- --           -- to expand the "bash" snippet, if the trigger_text is ";" I have to
-- --           -- type ";bash"
-- --           should_show_items = function()
-- --             local col = vim.api.nvim_win_get_cursor(0)[2]
-- --             local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
-- --             -- NOTE: remember that `trigger_text` is modified at the top of the file
-- --             return before_cursor:match(trigger_text .. '%w*$') ~= nil
-- --           end,
-- --           -- After accepting the completion, delete the trigger_text characters
-- --           -- from the final inserted text
-- --           transform_items = function(_, items)
-- --             local col = vim.api.nvim_win_get_cursor(0)[2]
-- --             local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
-- --             local trigger_pos = before_cursor:find(trigger_text .. '[^' .. trigger_text .. ']*$')
-- --             if trigger_pos then
-- --               for _, item in ipairs(items) do
-- --                 item.textEdit = {
-- --                   newText = item.insertText or item.label,
-- --                   range = {
-- --                     start = { line = vim.fn.line '.' - 1, character = trigger_pos - 1 },
-- --                     ['end'] = { line = vim.fn.line '.' - 1, character = col },
-- --                   },
-- --                 }
-- --               end
-- --             end
-- --             -- NOTE: After the transformation, I have to reload the luasnip source
-- --             -- Otherwise really crazy shit happens and I spent way too much time
-- --             -- figurig this out
-- --             vim.schedule(function()
-- --               require('blink.cmp').reload 'luasnip'
-- --             end)
-- --             return items
-- --           end,
-- --         },
-- --       },
-- --     }
-- --
-- --     opts.enabled = function()
-- --       return not vim.tbl_contains({ 'markdown' }, vim.bo.filetype) and vim.bo.buftype ~= 'prompt' and vim.b.completion ~= false
-- --     end
-- --     opts.snippets = {
-- --       expand = function(snippet)
-- --         require('luasnip').lsp_expand(snippet)
-- --       end,
-- --       active = function(filter)
-- --         if filter and filter.direction then
-- --           return require('luasnip').jumpable(filter.direction)
-- --         end
-- --         return require('luasnip').in_snippet()
-- --       end,
-- --       jump = function(direction)
-- --         require('luasnip').jump(direction)
-- --       end,
-- --     }
-- --
-- --     opts.completion = {
-- --       accept = {
-- --         -- experimental auto-brackets support
-- --         auto_brackets = {
-- --           enabled = true,
-- --         },
-- --       },
-- --       menu = {
-- --         draw = {
-- --           treesitter = { 'lsp' },
-- --         },
-- --       },
-- --       documentation = {
-- --         auto_show = true,
-- --         auto_show_delay_ms = 100,
-- --       },
-- --       ghost_text = {
-- --         enabled = vim.g.ai_cmp,
-- --       },
-- --       list = { selection = 'auto_insert' },
-- --     }
-- --     opts.snippets = {
-- --       expand = function(snippet)
-- --         require('luasnip').lsp_expand(snippet)
-- --       end,
-- --       active = function(filter)
-- --         if filter and filter.direction then
-- --           return require('luasnip').jumpable(filter.direction)
-- --         end
-- --         return require('luasnip').in_snippet()
-- --       end,
-- --       jump = function(direction)
-- --         require('luasnip').jump(direction)
-- --       end,
-- --     }
-- --     return opts
-- --   end,
-- --
-- --   -- opts_extend = { 'sources.default' },
-- -- }
-- -- -- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/blink-cmp.lua
-- -- -- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/blink-cmp.lua
-- --
-- -- -- completion plugin with support for LSPs and external sources that updates
-- -- -- on every keystroke with minimal overhead
-- --
-- -- -- https://www.lazyvim.org/extras/coding/blink
-- -- -- https://github.com/saghen/blink.cmp
-- -- -- Documentation site: https://cmp.saghen.dev/
-- --
-- -- -- NOTE: Specify the trigger character(s) used for luasnip
-- -- -- local trigger_text = ';'
-- -- --
-- -- -- return {
-- -- --   'saghen/blink.cmp',
-- -- --   enabled = true,
-- -- --   opts = function(_, opts)
-- -- --     -- Merge custom sources with the existing ones from lazyvim
-- -- --     -- NOTE: by default lazyvim already includes the lazydev source, so not adding it here again
-- -- --     opts.sources = vim.tbl_deep_extend('force', opts.sources or {}, {
-- -- --       default = { 'lsp', 'path', 'snippets', 'buffer', 'luasnip' },
-- -- --       providers = {
-- -- --         -- lsp = {
-- -- --         --   name = 'lsp',
-- -- --         --   enabled = true,
-- -- --         --   module = 'blink.cmp.sources.lsp',
-- -- --         --   kind = 'LSP',
-- -- --         --   -- When linking markdown notes, I would get snippets and text in the
-- -- --         --   -- suggestions, I want those to show only if there are no LSP
-- -- --         --   -- suggestions
-- -- --         --   -- Disabling fallbacks as my snippets woudlnt show up
-- -- --         --   -- fallbacks = { "luasnip", "buffer" },
-- -- --         --   score_offset = 90, -- the higher the number, the higher the priority
-- -- --         -- },
-- -- --         luasnip = {
-- -- --           name = 'luasnip',
-- -- --           enabled = true,
-- -- --           module = 'blink.cmp.sources.luasnip',
-- -- --           min_keyword_length = 2,
-- -- --           fallbacks = { 'snippets' },
-- -- --           score_offset = 85,
-- -- --           max_items = 8,
-- -- --           -- Only show luasnip items if I type the trigger_text characters, so
-- -- --           -- to expand the "bash" snippet, if the trigger_text is ";" I have to
-- -- --           -- type ";bash"
-- -- --           should_show_items = function()
-- -- --             local col = vim.api.nvim_win_get_cursor(0)[2]
-- -- --             local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
-- -- --             -- NOTE: remember that `trigger_text` is modified at the top of the file
-- -- --             return before_cursor:match(trigger_text .. '%w*$') ~= nil
-- -- --           end,
-- -- --           -- After accepting the completion, delete the trigger_text characters
-- -- --           -- from the final inserted text
-- -- --           transform_items = function(_, items)
-- -- --             local col = vim.api.nvim_win_get_cursor(0)[2]
-- -- --             local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
-- -- --             local trigger_pos = before_cursor:find(trigger_text .. '[^' .. trigger_text .. ']*$')
-- -- --             if trigger_pos then
-- -- --               for _, item in ipairs(items) do
-- -- --                 item.textEdit = {
-- -- --                   newText = item.insertText or item.label,
-- -- --                   range = {
-- -- --                     start = { line = vim.fn.line '.' - 1, character = trigger_pos - 1 },
-- -- --                     ['end'] = { line = vim.fn.line '.' - 1, character = col },
-- -- --                   },
-- -- --                 }
-- -- --               end
-- -- --             end
-- -- --             -- NOTE: After the transformation, I have to reload the luasnip source
-- -- --             -- Otherwise really crazy shit happens and I spent way too much time
-- -- --             -- figurig this out
-- -- --             vim.schedule(function()
-- -- --               require('blink.cmp').reload 'luasnip'
-- -- --             end)
-- -- --             return items
-- -- --           end,
-- -- --         },
-- -- --         path = {
-- -- --           name = 'Path',
-- -- --           module = 'blink.cmp.sources.path',
-- -- --           score_offset = 3,
-- -- --           -- When typing a path, I would get snippets and text in the
-- -- --           -- suggestions, I want those to show only if there are no path
-- -- --           -- suggestions
-- -- --           fallbacks = { 'luasnip', 'buffer' },
-- -- --           opts = {
-- -- --             trailing_slash = false,
-- -- --             label_trailing_slash = true,
-- -- --             get_cwd = function(context)
-- -- --               return vim.fn.expand(('#%d:p:h'):format(context.bufnr))
-- -- --             end,
-- -- --             show_hidden_files_by_default = true,
-- -- --           },
-- -- --         },
-- -- --         buffer = {
-- -- --           name = 'Buffer',
-- -- --           enabled = true,
-- -- --           max_items = 3,
-- -- --           module = 'blink.cmp.sources.buffer',
-- -- --           min_keyword_length = 4,
-- -- --         },
-- -- --         snippets = {
-- -- --           name = 'snippets',
-- -- --           enabled = true,
-- -- --           max_items = 3,
-- -- --           module = 'blink.cmp.sources.snippets',
-- -- --           min_keyword_length = 4,
-- -- --           score_offset = 80, -- the higher the number, the higher the priority
-- -- --         },
-- -- --         -- Example on how to configure dadbod found in the main repo
-- -- --         -- https://github.com/kristijanhusak/vim-dadbod-completion
-- -- --         -- dadbod = {
-- -- --         --   name = 'Dadbod',
-- -- --         --   module = 'vim_dadbod_completion.blink',
-- -- --         --   score_offset = 85, -- the higher the number, the higher the priority
-- -- --         -- },
-- -- --         -- Third class citizen mf always talking shit
-- -- --         -- copilot = {
-- -- --         --   name = 'copilot',
-- -- --         --   enabled = true,
-- -- --         --   module = 'blink-cmp-copilot',
-- -- --         --   kind = 'Copilot',
-- -- --         --   min_keyword_length = 6,
-- -- --         --   score_offset = -100, -- the higher the number, the higher the priority
-- -- --         --   async = true,
-- -- --         -- },
-- -- --       },
-- -- --       -- command line completion, thanks to dpetka2001 in reddit
-- -- --       -- https://www.reddit.com/r/neovim/comments/1hjjf21/comment/m37fe4d/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
-- -- --       cmdline = function()
-- -- --         local type = vim.fn.getcmdtype()
-- -- --         if type == '/' or type == '?' then
-- -- --           return { 'buffer' }
-- -- --         end
-- -- --         if type == ':' then
-- -- --           return { 'cmdline' }
-- -- --         end
-- -- --         return {}
-- -- --       end,
-- -- --     })
-- -- --
-- -- --     -- This comes from the luasnip extra, if you don't add it, won't be able to
-- -- --     -- jump forward or backward in luasnip snippets
-- -- --     -- https://www.lazyvim.org/extras/coding/luasnip#blinkcmp-optional
-- -- --     opts.snippets = {
-- -- --       expand = function(snippet)
-- -- --         require('luasnip').lsp_expand(snippet)
-- -- --       end,
-- -- --       active = function(filter)
-- -- --         if filter and filter.direction then
-- -- --           return require('luasnip').jumpable(filter.direction)
-- -- --         end
-- -- --         return require('luasnip').in_snippet()
-- -- --       end,
-- -- --       jump = function(direction)
-- -- --         require('luasnip').jump(direction)
-- -- --       end,
-- -- --     }
-- -- --
-- -- --     -- The default preset used by lazyvim accepts completions with enter
-- -- --     -- I don't like using enter because if on markdown and typing
-- -- --     -- something, but you want to go to the line below, if you press enter,
-- -- --     -- the completion will be accepted
-- -- --     -- https://cmp.saghen.dev/configuration/keymap.html#default
-- -- --     opts.keymap = {
-- -- --       preset = 'default',
-- -- --       ['<Tab>'] = { 'snippet_forward', 'fallback' },
-- -- --       ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
-- -- --
-- -- --       ['<C-k>'] = { 'select_prev', 'fallback' },
-- -- --       ['<C-j>'] = { 'select_next', 'fallback' },
-- -- --       ['<C-p>'] = { 'select_prev', 'fallback' },
-- -- --       ['<C-n>'] = { 'select_next', 'fallback' },
-- -- --
-- -- --       ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
-- -- --       ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
-- -- --
-- -- --       ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
-- -- --       ['<C-e>'] = { 'hide', 'fallback' },
-- -- --       ['<ENTER>'] = { 'accept', 'fallback' },
-- -- --     }
-- -- --
-- -- --     return opts
-- -- --   end,
-- -- -- }
