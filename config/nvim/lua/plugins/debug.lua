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

    -- Java DAP setup is handled by nvim-java plugin
    -- Use :JavaDapConfig to configure debug for a Java project
    -- Then use <leader>dg to start debugging

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
    
    -- Java DAP configuration - waits for JDTLS to be ready (for launch configs)
    vim.keymap.set('n', '<leader>ds', function()
      if vim.bo.filetype ~= 'java' then
        vim.notify('Not a Java file', vim.log.levels.WARN)
        return
      end
      
      -- Check if JDTLS is attached
      local clients = vim.lsp.get_clients({ bufnr = 0, name = 'jdtls' })
      if #clients == 0 then
        vim.notify('JDTLS not attached yet. Please wait for LSP to start.', vim.log.levels.WARN)
        return
      end
      
      vim.notify('Configuring Java DAP...', vim.log.levels.INFO)
      vim.cmd('JavaDapConfig')
      
      -- After config, show available configurations
      vim.defer_fn(function()
        local configs = dap.configurations.java
        if configs and #configs > 0 then
          vim.notify(string.format('✓ Configured %d debug configuration(s). Use <leader>dg to start.', #configs), vim.log.levels.INFO)
        end
      end, 500)
    end, { desc = 'Debug: Configure Java DAP (Launch)' })
    
    -- Java attach configuration - attach to running process on port 5005
    vim.keymap.set('n', '<leader>da', function()
      if vim.bo.filetype ~= 'java' then
        vim.notify('Not a Java file', vim.log.levels.WARN)
        return
      end
      
      -- Check if JDTLS is attached
      local clients = vim.lsp.get_clients({ bufnr = 0, name = 'jdtls' })
      if #clients == 0 then
        vim.notify('JDTLS not attached yet. Please wait for LSP to start.', vim.log.levels.WARN)
        return
      end
      
      local jdtls_client = clients[1]
      
      -- Request JDTLS to start debug session (get port for adapter)
      jdtls_client.request('workspace/executeCommand', {
        command = 'vscode.java.startDebugSession',
        arguments = {},
      }, function(err, result)
        if err or not result then
          vim.notify('Failed to start debug session: ' .. vim.inspect(err), vim.log.levels.ERROR)
          return
        end
        
        -- result is the port that JDTLS debug server is listening on
        local debug_port = tonumber(result)
        
        -- Set up adapter for attach mode
        dap.adapters.java = {
          type = 'server',
          host = '127.0.0.1',
          port = debug_port,
        }
        
        vim.notify('Attaching to port 5005...', vim.log.levels.INFO)
        
        -- Directly run the attach configuration without showing picker
        dap.run({
          type = 'java',
          request = 'attach',
          name = 'Attach to Java Process (port 5005)',
          hostName = '127.0.0.1',
          port = 5005,
          -- Additional options for better debugging
          projectName = vim.fn.fnamemodify(vim.fn.getcwd(), ':t'),
          -- Enable source lookup in multiple locations
          sourcePaths = { vim.fn.getcwd() .. '/src/main/java', vim.fn.getcwd() .. '/src' },
        })
      end, 0)
    end, { desc = 'Debug: Attach to Java Process' })
    
    vim.keymap.set('n', '<leader>dx', dap.close, { desc = 'Debug: Stop' })
    vim.keymap.set('n', '<leader>do', dapui.open, { desc = 'Dapui: Open' })
    vim.keymap.set('n', '<leader>dc', dapui.close, { desc = 'Dapui: Close' })
    
    -- Enhanced breakpoint toggle with feedback
    vim.keymap.set('n', '<leader>b', function()
      dap.toggle_breakpoint()
      local breakpoints = require('dap.breakpoints').get()
      local buf_bps = breakpoints[vim.api.nvim_get_current_buf()]
      if buf_bps and #buf_bps > 0 then
        vim.notify(string.format('Breakpoint set (total: %d in this file)', #buf_bps), vim.log.levels.INFO)
      else
        vim.notify('Breakpoint removed', vim.log.levels.INFO)
      end
    end, { desc = 'Debug: Toggle Breakpoint' })
    
    -- Show DAP status
    vim.keymap.set('n', '<leader>di', function()
      local breakpoints = require('dap.breakpoints').get()
      local total_bps = 0
      local bp_details = {}
      
      for bufnr, buf_bps in pairs(breakpoints) do
        total_bps = total_bps + #buf_bps
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local filename = vim.fn.fnamemodify(bufname, ':t')
        for _, bp in ipairs(buf_bps) do
          table.insert(bp_details, string.format('  %s:%d', filename, bp.line))
        end
      end
      
      local session = dap.session()
      local session_status = session and 'ACTIVE' or 'not started'
      
      local status = string.format(
        'Debug Status:\nBreakpoints: %d | Session: %s',
        total_bps,
        session_status
      )
      
      if #bp_details > 0 then
        status = status .. '\n\nBreakpoints:\n' .. table.concat(bp_details, '\n')
      end
      
      if session then
        status = status .. '\n\nSession active - breakpoints should trigger'
      end
      
      vim.notify(status, vim.log.levels.INFO)
    end, { desc = 'Debug: Show Status' })
    
    -- View DAP logs
    vim.keymap.set('n', '<leader>dl', function()
      vim.cmd('e ' .. vim.fn.stdpath('cache') .. '/dap.log')
    end, { desc = 'Debug: View Logs' })
    
    -- Check if port 5005 is listening and show process info
    vim.keymap.set('n', '<leader>dp', function()
      local handle = io.popen('lsof -i :5005 2>/dev/null')
      if not handle then
        vim.notify('Could not check port 5005', vim.log.levels.ERROR)
        return
      end
      local result = handle:read('*a')
      handle:close()
      
      if result == '' then
        vim.notify('❌ No process listening on port 5005\n\nStart your Java app with:\n-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005', vim.log.levels.ERROR)
      else
        vim.notify('✓ Port 5005 status:\n' .. result, vim.log.levels.INFO)
      end
    end, { desc = 'Debug: Check port 5005' })
    
    -- Open REPL for debugging
    vim.keymap.set('n', '<leader>dr', function()
      dap.repl.open()
    end, { desc = 'Debug: Open REPL' })
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
      expand_lines = false, -- Disable hover popup for long lines
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

    -- DAP event listeners - minimal notifications
    dap.listeners.after.event_terminated['user_notify'] = function()
      vim.notify('Debug session terminated', vim.log.levels.WARN)
    end
    
    dap.listeners.after.event_initialized['user_notify'] = function()
      vim.notify('✓ Debugger attached and ready', vim.log.levels.INFO)
    end
    
    -- Notify when breakpoints are set/verified
    dap.listeners.after.setBreakpoints['user_notify'] = function(session, body)
      if body and body.breakpoints then
        local verified = 0
        local unverified = 0
        for _, bp in ipairs(body.breakpoints) do
          if bp.verified then
            verified = verified + 1
          else
            unverified = unverified + 1
          end
        end
        if unverified > 0 then
          vim.notify(
            string.format('⚠️  Breakpoints: %d verified, %d unverified (may not stop)', verified, unverified),
            vim.log.levels.WARN
          )
        end
      end
    end
    
    -- Optionally auto-open/close dapui
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
