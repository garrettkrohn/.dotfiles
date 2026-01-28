-- this is a minimal config used for dadview, there is a memory leak somewhere in my other config
require 'config.options'

-- Set up paths for isolated environment
local lazypath = vim.fn.stdpath 'data' .. '/lazy-minimal/lazy.nvim'
local lazyvimpath = vim.fn.stdpath 'data' .. '/lazy-minimal/LazyVim'

-- Clone lazy.nvim if not present
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Set up lazy.nvim
require('lazy').setup {
  {
    dir = '/Users/gkrohn/code/neovim_plugins/dadview.nvim',
    lazy = false,
    name = 'dadview',
    dependencies = {
      'tpope/vim-dadbod',
    },
    config = function()
      local function pass(entry)
        return vim.fn.system('pass ' .. entry):gsub('\n', '')
      end

      vim.g.dbs = {
        {
          name = 'platform_local',
          url = string.format('postgresql://postgres:%s@localhost:4432/novaapi', 'postgres'),
        },
        {
          name = 'platform_dev',
          url = string.format('postgresql://gkrohn:%s@localhost:1111/novaapi', pass 'dev01'),
        },
        {
          name = 'platform_dev_workflow',
          url = string.format('postgresql://gkrohn:%s@localhost:1111/workflow_engine', pass 'dev01'),
        },
        {
          name = 'platform_ptx',
          url = string.format('postgresql://gkrohn:%s@localhost:1111/novaapi', pass 'ptx01'),
        },
        {
          name = 'platform_prod',
          url = string.format('postgresql://gkrohn:%s@localhost:1111/novaapi', pass 'prod01'),
        },
        {
          name = 'platform_prod_workflow_engine',
          url = string.format('postgresql://gkrohn:%s@localhost:1111/workflow_engine', pass 'prod01'),
        },
        {
          name = 'ctl_local',
          url = string.format('postgresql://myuser:%s@localhost:1432/warehouse', pass 'ctl/local'),
        },
        {
          name = 'ctl_dev',
          url = string.format('postgresql://garrett.krohn:%s@localhost:1111/warehouse', pass 'dw01'),
        },
      }

      require('dadview').setup {
        width = 40,
        position = 'left',
        auto_open_query_buffer = true,
      }
    end,
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    enabled = not vim.g.disable_blink,
    dependencies = {
      'brenoprata10/nvim-highlight-colors',
      'folke/lazydev.nvim',
      'MahanRahmati/blink-nerdfont.nvim',
      'moyiz/blink-emoji.nvim',
      'rafamadriz/friendly-snippets',
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
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
        default = { 'lsp', 'dadbod', 'path', 'snippets', 'buffer', 'emoji', 'nerdfont' },
        providers = {
          dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
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
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
  {

    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile', 'BufWritePre' },
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- dap
      'mfussenegger/nvim-dap',
      { 'jay-babu/mason-nvim-dap.nvim' },

      -- Faster LuaLS setup for Neovim
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            { 'nvim-dap-ui' },
          },
        },
      },

      -- Useful status updates for LSP.
      {
        'j-hui/fidget.nvim',
        opts = {
          notification = {
            window = {
              winblend = 0,
              align = 'top',
            },
          },
        },
      },

      -- autocomplete
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('jam-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          -- (Using Snacks keymaps instead - see snacks.lua)
          -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Jump to the declaration of the word under your cursor.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Find references for the word under your cursor.
          -- (Using Snacks keymaps instead - see snacks.lua)
          -- map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          -- (Using Snacks keymaps instead - see snacks.lua)
          -- map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Incremental rename
          -- map('<leader>rN', require('inc_rename').rename(vim.fn.expand '<cword>'), 'Incremental LSP renaming', { 'n' })

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- local lspIcons = require('utils.icons').lsp
      -- vim.diagnostic.config {
      --   severity_sort = true,
      --   float = { border = 'rounded', source = 'if_many' },
      --   underline = { severity = vim.diagnostic.severity.ERROR },
      --   signs = { text = { ERROR = '', WARN = '', INFO = '', HINT = '' } },
      --   virtual_text = {
      --     -- TODO: setup neovim plugin that allows the value to be toggled based on the comment line above it (or LSP value?)
      --     -- 'eol', 'inline', 'overlay', 'right_align'
      --     virt_text_pos = 'eol',
      --     prefix = '',
      --     format = function(diagnostic)
      --       local icons = {
      --         [vim.diagnostic.severity.ERROR] = lspIcons.error,
      --         [vim.diagnostic.severity.WARN] = lspIcons.warn,
      --         [vim.diagnostic.severity.INFO] = lspIcons.info,
      --         [vim.diagnostic.severity.HINT] = lspIcons.hint,
      --       }
      --       return string.format('%s %s', icons[diagnostic.severity], diagnostic.message)
      --     end,
      --   },
      -- }

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        gopls = {},

        eslint = {
          settings = { workingDirectories = { mode = 'auto' } },
          filetypes = {
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
          },
        },

        ts_ls = {
          filetypes = {
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
          },
        },
        tailwindcss = {
          filetypes = {
            'astro',
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
          },
        },

        graphql = {
          filetypes = {
            'graphql',
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
          },
        },

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },

        jsonls = {
          -- filetypes = {
          --   'json',
          -- },
          -- settings = {
          --   json = {
          --     format = { enable = true },
          --     validate = { enable = true },
          --   },
          -- },
        },
      }

      ---@type MasonLspconfigSettings
      ---@diagnostic disable-next-line: missing-fields
      require('mason-lspconfig').setup {
        automatic_enable = vim.tbl_keys(servers or {}),
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'typescript-language-server',
        'js-debug-adapter',
        'gopls',
        'delve',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- Setup each LSP server with its configuration
      local lspconfig = require 'lspconfig'
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      for server_name, config in pairs(servers) do
        -- Merge user config with capabilities
        local server_config = vim.tbl_deep_extend('force', {
          capabilities = capabilities,
        }, config)

        lspconfig[server_name].setup(server_config)
      end

      -- vim.lsp.inline_completion.enable()

      -- vim.keymap.set('i', '<Tab>', function()
      --   if not vim.lsp.inline_completion.get() then
      --     return '<Tab>'
      --   end
      -- end, { expr = true, desc = 'Accept the current inline completion' })

      require('mason-nvim-dap').setup()
    end,
  },
  {
    'catppuccin/nvim',
    enabled = true,
    lazy = false,
    name = 'catppuccin',
    priority = 1000,
    flavour = 'mocha',
    transparent_background = true,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = true, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
          shade = 'dark',
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { 'italic' }, -- Change the style of comments
          conditionals = { 'italic' },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {},
        custom_highlights = {
          LineNr = { fg = '#f8f8f2' },
        },
        default_integrations = true,
        integrations = {
          blink_cmp = true,
          cmp = true,
          diffview = true,
          gitsigns = true,
          mason = true,
          neotest = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope_color = '',
          },
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      }

      -- setup must be called before loading
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}

require 'config.keymaps'
require 'config.autocommands'
require 'config.user_functions'
vim.api.nvim_create_user_command('MemoryCheck', function(opts)
  local pid = opts.args

  -- If no PID provided, try to get it from current buffer
  if pid == '' then
    -- Try to get PID from buffer name (common for terminal buffers)
    local bufname = vim.api.nvim_buf_get_name(0)

    -- Check if it's a terminal buffer
    if vim.bo.buftype == 'terminal' then
      -- Get the job ID and then the PID
      local chan_id = vim.b.terminal_job_id
      if chan_id then
        pid = vim.fn.jobpid(chan_id)
      end
    end

    -- If still no PID, check buffer name for patterns like "term://...//12345:..."
    if not pid then
      pid = bufname:match ':(%d+):'
    end

    -- Last resort: use Neovim's own PID
    if not pid then
      pid = vim.fn.getpid()
      print('No process found in buffer, using Neovim PID: ' .. pid)
    end
  end

  -- Use ps to get memory info
  local result = vim.fn.system(string.format('ps -p %s -o rss,vsz,%%mem,command', pid))

  if vim.v.shell_error ~= 0 then
    print('Error: Process not found or invalid PID: ' .. pid)
    return
  end

  -- Display in a floating window
  local lines = vim.split(result, '\n')
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = 80
  local height = #lines
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = 'minimal',
    border = 'rounded',
    title = ' Memory Usage for PID ' .. pid .. ' ',
    title_pos = 'center',
  })

  -- Close on any key
  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf })
  vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf })
end, {
  nargs = '?', -- Optional argument
  desc = 'Check memory usage for a given PID or current buffer process',
})
