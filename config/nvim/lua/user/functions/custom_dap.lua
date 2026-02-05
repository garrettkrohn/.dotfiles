local M = {}

--- Check if jdtls (Java LSP) is attached and running
local function is_jdtls_attached()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  for _, client in ipairs(clients) do
    if client.name == 'jdtls' then
      return client
    end
  end
  return nil
end

--- Get the fully qualified class name from current buffer
local function get_class_name()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local package_name = nil
  local class_name = nil

  -- Find package and class declarations
  for _, line in ipairs(lines) do
    if not package_name then
      local pkg = line:match '^%s*package%s+([%w%.]+)'
      if pkg then
        package_name = pkg
      end
    end

    if not class_name then
      local cls = line:match '^%s*public%s+class%s+(%w+)'
      if cls then
        class_name = cls
      end
    end

    if package_name and class_name then
      break
    end
  end

  if not class_name then
    return nil
  end

  if package_name then
    return package_name .. '.' .. class_name
  else
    return class_name
  end
end

--- Check if a port is listening for connections
local function is_port_listening(port)
  local handle = io.popen(string.format('lsof -i :%d -sTCP:LISTEN 2>/dev/null', port))
  if not handle then
    return false, 'Could not run lsof command'
  end
  local result = handle:read '*a'
  handle:close()

  if result and result ~= '' then
    -- Return the process info for debugging
    return true, result
  end
  return false, 'No process listening'
end

--- Test TCP connection to port
local function test_connection(host, port)
  local uv = vim.loop
  local client = uv.new_tcp()
  local connected = false
  local error_msg = nil

  client:connect(host, port, function(err)
    if err then
      error_msg = err
    else
      connected = true
    end
    client:close()
  end)

  -- Wait a bit for connection attempt
  vim.wait(1000, function()
    return connected or error_msg ~= nil
  end)

  return connected, error_msg
end

--- Setup Java debug adapter and configurations
local function setup_java_dap()
  local dap = require 'dap'

  -- Get jdtls client
  local jdtls_client = is_jdtls_attached()
  if not jdtls_client then
    vim.notify('❌ jdtls not attached - cannot set up debug adapter', vim.log.levels.ERROR)
    return false
  end

  -- Set up the adapter using jdtls's DAP server capability
  dap.adapters.java = function(callback, config)
    -- Request jdtls to start a debug session
    jdtls_client.request('workspace/executeCommand', {
      command = 'vscode.java.startDebugSession',
      arguments = {},
    }, function(err, result)
      if err or not result then
        vim.notify('Failed to start debug session: ' .. vim.inspect(err), vim.log.levels.ERROR)
        return
      end

      -- result should contain the port jdtls DAP server is listening on
      callback {
        type = 'server',
        host = '127.0.0.1',
        port = tonumber(result),
      }
    end, 0)
  end

  -- Set up configurations
  dap.configurations.java = {
    {
      type = 'java',
      request = 'attach',
      name = 'Attach to Java Process (port 5005)',
      hostName = '127.0.0.1',
      port = 5005,
    },
    {
      type = 'java',
      request = 'attach',
      name = 'Attach to Custom Port',
      hostName = '127.0.0.1',
      port = function()
        return tonumber(vim.fn.input('Port: ', '5005'))
      end,
    },
  }

  return true
end

--- Attach to Java debug session
local function start_java_debug()
  local dap = require 'dap'
  local debug_port = 5005
  local host = '127.0.0.1'

  -- Setup adapter and configurations if not already done
  if not dap.adapters.java or not dap.configurations.java then
    -- vim.notify('Setting up Java DAP adapter and configurations...', vim.log.levels.INFO)
    if not setup_java_dap() then
      return
    end
  end

  -- vim.notify('Checking debug server on port ' .. debug_port .. '...', vim.log.levels.INFO)

  -- Check if debug port is listening
  local listening, port_info = is_port_listening(debug_port)
  if not listening then
    vim.notify(
      string.format(
        '❌ No debug server found on port %d\n\nMake sure your Java process is running with:\n-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:%d\n\nTo check manually run:\nlsof -i :%d',
        debug_port,
        debug_port,
        debug_port
      ),
      vim.log.levels.ERROR
    )
    return
  end

  -- vim.notify('✓ Found process listening:\n' .. vim.trim(port_info), vim.log.levels.INFO)

  -- Test actual TCP connection
  -- vim.notify('Testing connection to ' .. host .. ':' .. debug_port .. '...', vim.log.levels.INFO)
  local connected, err = test_connection(host, debug_port)

  if not connected then
    vim.notify(
      string.format(
        '❌ Cannot connect to %s:%d\nError: %s\n\nCheck DAP logs at: %s\n\nTry:\n1. Verify Java process is bound to 0.0.0.0 or 127.0.0.1\n2. Check firewall settings\n3. Run: telnet %s %d',
        host,
        debug_port,
        err or 'unknown',
        vim.fn.stdpath 'cache' .. '/dap.log',
        host,
        debug_port
      ),
      vim.log.levels.ERROR
    )
    return
  end

  -- vim.notify('✓ Connection test successful', vim.log.levels.INFO)
  vim.notify('Attaching debugger using java-debug adapter...', vim.log.levels.INFO)

  -- Use attach configuration with the java-debug adapter
  local config = {
    type = 'java',
    request = 'attach',
    name = 'Attach to Java Process (port ' .. debug_port .. ')',
    hostName = host,
    port = debug_port,
  }

  -- Show where to find logs
  vim.notify('DAP logs: ' .. vim.fn.stdpath 'cache' .. '/dap.log', vim.log.levels.INFO)

  dap.run(config)
end

function M.setup()
  local dap = require 'dap'

  -- Check if we're in a Java buffer and jdtls is attached
  if vim.bo.filetype == 'java' and is_jdtls_attached() then
    -- Use jdtls-specific debug functionality
    start_java_debug()
    return
  end

  -- Not in a Java buffer or jdtls not attached
  if vim.bo.filetype ~= 'java' then
    vim.notify('Please open a Java file before debugging Java applications.', vim.log.levels.WARN)
    return
  end

  -- In a Java buffer but jdtls not attached yet, wait for it
  vim.notify('Waiting for Java LSP to attach...', vim.log.levels.INFO)
  vim.defer_fn(function()
    if is_jdtls_attached() then
      start_java_debug()
    else
      vim.notify('Java LSP failed to attach. Check your Java setup.', vim.log.levels.ERROR)
    end
  end, 1000)
end

function M.globalServiceSetup()
  local dap = require 'dap'

  if vim.bo.filetype == 'java' and is_jdtls_attached() then
    start_java_debug()
    return
  end

  if vim.bo.filetype ~= 'java' then
    vim.notify('Please open a Java file before debugging.', vim.log.levels.WARN)
    return
  end

  vim.notify('Waiting for Java LSP...', vim.log.levels.INFO)
  vim.defer_fn(function()
    if is_jdtls_attached() then
      start_java_debug()
    else
      vim.notify('Java LSP not ready.', vim.log.levels.ERROR)
    end
  end, 1000)
end

--- View DAP logs
function M.view_logs()
  local log_path = vim.fn.stdpath 'cache' .. '/dap.log'
  if vim.fn.filereadable(log_path) == 0 then
    vim.notify('No DAP log file found at: ' .. log_path, vim.log.levels.WARN)
    return
  end
  vim.cmd('vsplit ' .. log_path)
  vim.cmd 'normal! G' -- Go to end of file
end

--- Check DAP configuration status
function M.check_config()
  local dap = require 'dap'

  vim.notify('=== DAP Configuration Status ===', vim.log.levels.INFO)

  if dap.adapters.java then
    vim.notify('✓ Java adapter: configured', vim.log.levels.INFO)
  else
    vim.notify('✗ Java adapter: NOT configured', vim.log.levels.WARN)
  end

  if dap.configurations.java then
    vim.notify('✓ Java configurations: ' .. #dap.configurations.java .. ' configs', vim.log.levels.INFO)
    for i, config in ipairs(dap.configurations.java) do
      vim.notify('  ' .. i .. '. ' .. config.name, vim.log.levels.INFO)
    end
  else
    vim.notify('✗ Java configurations: NOT configured', vim.log.levels.WARN)
  end

  local jdtls_client = is_jdtls_attached()
  if jdtls_client then
    vim.notify('✓ jdtls: attached', vim.log.levels.INFO)
  else
    vim.notify('✗ jdtls: NOT attached', vim.log.levels.WARN)
  end
end

vim.cmd 'command! Dap lua require("user_functions.custom_dap").setup()'
vim.cmd 'command! DapLogs lua require("user_functions.custom_dap").view_logs()'
vim.cmd 'command! DapStatus lua require("user_functions.custom_dap").check_config()'
return M
