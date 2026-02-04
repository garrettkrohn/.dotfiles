-- Minimal config for dadview (memory leak workaround)
-- Uses new organized structure

require 'config.core.options'

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
            opts = {},
          },
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
          nerdfont = {
            module = 'blink-nerdfont',
            name = 'Nerd Fonts',
            score_offset = 15,
            opts = { insert = true },
          },
          opencode = {
            module = 'opencode.cmp.blink',
          },
          emoji = {
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
      'mfussenegger/nvim-dap',
      { 'jay-babu/mason-nvim-dap.nvim' },
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
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('jam-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

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

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

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
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
            },
          },
        },
        jsonls = {},
      }

      require('mason-lspconfig').setup {
        automatic_enable = vim.tbl_keys(servers or {}),
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        'typescript-language-server',
        'js-debug-adapter',
        'gopls',
        'delve',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      local lspconfig = require 'lspconfig'
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      for server_name, config in pairs(servers) do
        local server_config = vim.tbl_deep_extend('force', {
          capabilities = capabilities,
        }, config)

        lspconfig[server_name].setup(server_config)
      end
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
        flavour = 'mocha',
        background = {
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = true,
        show_end_of_buffer = false,
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = 'dark',
          percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = { 'italic' },
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
        },
      }

      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'christoomey/vim-tmux-navigator',
    event = 'BufEnter *',
  },
  {
    lazy = false,
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      show_hidden = true,
    },
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  },
}

require 'config.core.keymaps'
require 'config.core.autocommands'
require 'config.core.user-functions'
