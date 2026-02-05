-- Consolidated LSP Configuration Module
local M = {}

-- LSP server configurations
M.servers = {
  gopls = {},

  jdtls = {
    -- Use Java 21 explicitly
    cmd = {
      vim.fn.stdpath 'data' .. '/mason/bin/jdtls',
      '--java-executable',
      '/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home/bin/java',
    },
    init_options = {
      bundles = {
        vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/packages/java-debug-adapter/extension/server/*.jar', 1),
      },
    },
    settings = {
      java = {
        configuration = {
          updateBuildConfiguration = 'automatic',
        },
      },
    },
  },

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

-- Tools to ensure are installed (formatters, linters, debug adapters)
-- Note: LSP servers are automatically installed by mason-lspconfig
M.ensure_installed = {
  'stylua',
  'js-debug-adapter',
  'delve',
}

-- Setup LSP attach keymaps
function M.on_attach(event)
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  -- Jump to the declaration of the word under your cursor.
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Jump to the type of the word under your cursor.
  map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

  -- Fuzzy find all the symbols in your current workspace.
  map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- Rename the variable under your cursor.
  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  -- Helper function for version compatibility
  local function client_supports_method(client, method, bufnr)
    if vim.fn.has 'nvim-0.11' == 1 then
      return client:supports_method(method, bufnr)
    else
      return client.supports_method(method, { bufnr = bufnr })
    end
  end

  -- Document highlight on cursor hold
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

  -- Toggle inlay hints
  if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
    map('<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
    end, '[T]oggle Inlay [H]ints')
  end
end

-- Setup function to be called by the lspconfig plugin
function M.setup()
  -- Create LspAttach autocmd
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('jam-lsp-attach', { clear = true }),
    callback = M.on_attach,
  })

  -- Setup mason-lspconfig
  require('mason-lspconfig').setup {
    automatic_enable = vim.tbl_keys(M.servers or {}),
  }

  -- Setup mason-tool-installer
  -- Only install additional tools (formatters, linters, debug adapters)
  -- LSP servers are handled by mason-lspconfig automatically
  require('mason-tool-installer').setup { ensure_installed = M.ensure_installed }

  -- Get capabilities from blink.cmp
  local capabilities = require('blink.cmp').get_lsp_capabilities()

  -- Setup each LSP server using vim.lsp.config (new API in nvim 0.11)
  for server_name, config in pairs(M.servers) do
    local server_config = vim.tbl_deep_extend('force', {
      capabilities = capabilities,
    }, config)

    -- Handle jdtls specially - force parent directory as root
    if server_name == 'jdtls' then
      server_config.root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local parent_dir = vim.fn.expand '~/code/platform_work/ENG-131_scanner_dsl_setup/parent'
        
        -- Check if file is in the parent directory
        if fname:match('^' .. vim.pesc(parent_dir)) then
          on_dir(parent_dir)
          return
        end

        -- Fallback to standard root markers
        local root = vim.fs.root(bufnr, { 'pom.xml', 'build.gradle', '.git' })
        if root then
          on_dir(root)
        end
      end
    end

    -- Register the LSP server configuration using the new API
    vim.lsp.config[server_name] = server_config
    
    -- Enable the server (this replaces lspconfig[server_name].setup())
    vim.lsp.enable(server_name)
  end
end

return M
