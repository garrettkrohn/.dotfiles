return {
  'mfussenegger/nvim-dap',
  -- Load lazily on first use, but make commands available
  cmd = { 'DapContinue', 'DapToggleBreakpoint', 'DapStepOver', 'DapStepInto', 'DapStepOut' },
  keys = {
    { '<leader>dg', desc = 'Debug: Start/Continue' },
    { '<leader>b', desc = 'Debug: Toggle Breakpoint' },
    { '<F1>', desc = 'Debug: Step Over' },
    { '<F2>', desc = 'Debug: Step Into' },
    { '<F3>', desc = 'Debug: Step Out' },
  },
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'nvim-neotest/nvim-nio',

    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Set DAP log level before any debug sessions
    -- Valid levels: TRACE, DEBUG, INFO, WARN, ERROR
    dap.set_log_level 'DEBUG'

    -- Java DAP setup is handled by nvim-java plugin with java_debug_adapter enabled
    -- No manual adapter configuration needed here

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      handlers = {
        function(config)
          require('mason-nvim-dap').default_setup(config)
        end,
      },

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }
    
    -- Install golang specific config
    require('dap-go').setup()

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<leader>dg', dap.continue, { desc = 'Debug: Start/Continue' })
    
    -- vim.keymap.set('n', '<F1>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F2>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>ds', dap.close, { desc = 'Debug: Stop' })
    vim.keymap.set('n', '<leader>do', dapui.open, { desc = 'Dapui: Open' })
    vim.keymap.set('n', '<leader>dc', dapui.close, { desc = 'Dapui: Close' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        enabled = false,
        element = 'repl',
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      layouts = {
        {
          elements = {
            {
              id = 'scopes',
              size = 0.5,
            },
            {
              id = 'breakpoints',
              size = 0.25,
            },
            {
              id = 'watches',
              size = 0.25,
            },
          },
          position = 'left',
          size = 60,
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    -- Disable hover popups in dapui windows
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'dapui_*',
      callback = function(event)
        -- Disable LSP hover keymaps in dapui buffers
        vim.keymap.set('n', 'K', '<Nop>', { buffer = event.buf })
        vim.keymap.set('n', '<leader>ty', '<Nop>', { buffer = event.buf })
      end,
    })

    -- dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    -- dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- colors for debugger
    vim.cmd 'highlight DapStopped guifg=#40a02b gui=bold'
    vim.cmd 'highlight DapBreakpoint guifg=#4c4f69 guibg=#7287fd gui=bold'

    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition', { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
  end,
}
